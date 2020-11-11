/*
  Copyright (c) 2015 Arduino LLC.  All right reserved.
  Copyright (c) 2015 Atmel Corporation/Thibaut VIARD.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#include <stdio.h>
#include <sam.h>
#include "sam_ba_monitor.h"
#include "sam_ba_serial.h"
#include "board_definitions.h"
#include "board_driver_led.h"
#include "board_driver_i2c.h"
#include "board_driver_pmic.h"
#include "board_driver_jtag.h"
#include "sam_ba_usb.h"
#include "sam_ba_cdc.h"

extern uint32_t __sketch_vectors_ptr; // Exported value from linker script
extern void board_init(void);

#define BOOTLOADER_WAIT_TIME_MS 9600  // 200ms ( * 48)
#define FPGA_CONFIG_STARTTIME_MS 4800 // 100ms
volatile bool jump_on_timeout = false;
volatile bool start_fpga_config = false;
volatile bool config_done = false;
volatile uint16_t jump_cnt = 0;

volatile uint32_t* pulSketch_Start_Address;

static void jump_to_application(void) {

  /* Rebase the Stack Pointer */
  __set_MSP( (uint32_t)(__sketch_vectors_ptr) );

  /* Rebase the vector table base address */
  SCB->VTOR = ((uint32_t)(&__sketch_vectors_ptr) & SCB_VTOR_TBLOFF_Msk);

  /* Jump to application Reset Handler in the application */
  asm("bx %0"::"r"(*pulSketch_Start_Address));
}

static volatile bool main_b_cdc_enable = false;

#ifdef CONFIGURE_PMIC
static volatile bool jump_to_app = false;
#endif

/**
 * \brief Check the application startup condition
 *
 */
static void check_start_application(void)
{
  /*
   * Test sketch stack pointer @ &__sketch_vectors_ptr
   * Stay in SAM-BA if value @ (&__sketch_vectors_ptr) == 0xFFFFFFFF (Erased flash cell value)
   */
  if (__sketch_vectors_ptr == 0xFFFFFFFF)
  {
    /* Stay in bootloader */
    return;
  }

  /*
   * Load the sketch Reset Handler address
   * __sketch_vectors_ptr is exported from linker script and point on first 32b word of sketch vector table
   * First 32b word is sketch stack
   * Second 32b word is sketch entry point: Reset_Handler()
   */
  pulSketch_Start_Address = &__sketch_vectors_ptr ;
  pulSketch_Start_Address++ ;

  /*
   * Test vector table address of sketch @ &__sketch_vectors_ptr
   * Stay in SAM-BA if this function is not aligned enough, ie not valid
   */
  if ( ((uint32_t)(&__sketch_vectors_ptr) & ~SCB_VTOR_TBLOFF_Msk) != 0x00)
  {
    /* Stay in bootloader */
    return;
  }

#if defined(BOOT_DOUBLE_TAP_ADDRESS)
  #define DOUBLE_TAP_MAGIC 0x07738135
  if (PM->RCAUSE.bit.POR)
  {
    /* On power-on initialize double-tap */
    BOOT_DOUBLE_TAP_DATA = 0;
  }
  else
  {
    if (BOOT_DOUBLE_TAP_DATA == DOUBLE_TAP_MAGIC)
    {
      /* Second tap, stay in bootloader */
      BOOT_DOUBLE_TAP_DATA = 0;
      return;
    }

#ifdef HAS_EZ6301QI
    // wait a tiny bit for the EZ6301QI to settle,
    // as it's connected to RESETN and might reset
    // the chip when the cable is plugged in fresh

    for (uint32_t i=0; i<2500; i++) /* 10ms */
      /* force compiler to not optimize this... */
      __asm__ __volatile__("");
#endif

    /* First tap */
    BOOT_DOUBLE_TAP_DATA = DOUBLE_TAP_MAGIC;

    /* Wait 0.5sec to see if the user tap reset again.
     * The loop value is based on SAMD21 default 1MHz clock @ reset.
     */
    for (uint32_t i=0; i<125000; i++) /* 500ms */
      /* force compiler to not optimize this... */
      __asm__ __volatile__("");

    /* Timeout happened, continue boot... */
    BOOT_DOUBLE_TAP_DATA = 0;
  }
#endif

#if defined(BOOT_LOAD_PIN)
  volatile PortGroup *boot_port = (volatile PortGroup *)(&(PORT->Group[BOOT_LOAD_PIN / 32]));
  volatile bool boot_en;

  // Enable the input mode in Boot GPIO Pin
  boot_port->DIRCLR.reg = BOOT_PIN_MASK;
  boot_port->PINCFG[BOOT_LOAD_PIN & 0x1F].reg = PORT_PINCFG_INEN | PORT_PINCFG_PULLEN;
  boot_port->OUTSET.reg = BOOT_PIN_MASK;
  // Read the BOOT_LOAD_PIN status
  boot_en = (boot_port->IN.reg) & BOOT_PIN_MASK;

  // Check the bootloader enable condition
  if (!boot_en)
  {
    // Stay in bootloader
    return;
  }
#endif

#ifdef CONFIGURE_PMIC
  jump_to_app = true;
#else
  jump_to_application();
#endif

}

#if DEBUG_ENABLE
#	define DEBUG_PIN_HIGH 	port_pin_set_output_level(BOOT_LED, 1)
#	define DEBUG_PIN_LOW 	port_pin_set_output_level(BOOT_LED, 0)
#else
#	define DEBUG_PIN_HIGH 	do{}while(0)
#	define DEBUG_PIN_LOW 	do{}while(0)
#endif

void initFPGASPI()
{
  // Enable SERCOM3 as SPI to FPGA
  PORT->Group[0].PMUX[11].reg = 0x22;    // Peripherial MUX for PA22 and PA23
  PORT->Group[0].PINCFG[22].bit.PMUXEN = 1;  // Enable peripherial pin
  PORT->Group[0].PINCFG[23].bit.PMUXEN = 1;  // Enable peripherial pin

  //Setting the Software Reset bit to 1
  SERCOM3->SPI.CTRLA.bit.SWRST = 1;
  //Wait both bits Software Reset from CTRLA and SYNCBUSY are equal to 0
  while(SERCOM3->SPI.CTRLA.bit.SWRST || SERCOM3->SPI.SYNCBUSY.bit.SWRST);

  // Enable clock to SERCOM3
  GCLK->CLKCTRL.reg = GCLK_CLKCTRL_ID( GCLK_CLKCTRL_ID_SERCOM3_CORE_Val ) | // Generic Clock 0 (SERCOMx)
                      GCLK_CLKCTRL_GEN_GCLK0 | // Generic Clock Generator 0 is source
                      GCLK_CLKCTRL_CLKEN ;
  PM->APBCMASK.reg |= PM_APBCMASK_SERCOM3;

  SERCOM3->SPI.CTRLA.reg = SERCOM_SPI_CTRLA_MODE_SPI_MASTER |
                           SERCOM_SPI_CTRLA_DOPO(0) |
                           SERCOM_SPI_CTRLA_DIPO(3);
  SERCOM3->SPI.CTRLA.bit.CPOL = 0;
  SERCOM3->SPI.CTRLA.bit.CPHA = 0;
  SERCOM3->SPI.CTRLB.reg = SERCOM_SPI_CTRLB_RXEN;	//Active the SPI receiver.  
  SERCOM3->SPI.BAUD.reg = 7;  // 3 MHz SPI

  SERCOM3->SPI.CTRLA.bit.ENABLE = 1;
  while(SERCOM3->SPI.SYNCBUSY.bit.ENABLE);
}

void initFlashSPI()
{
  PORT->Group[0].OUTSET.reg = 1 << 18;  // Set pin HIGH
  PORT->Group[0].DIRSET.reg = 1 << 18;  // Set pin PA18 as output

  // Enable SERCOM1 as SPI to Flash
  PORT->Group[0].PMUX[8].reg = 0x22;    // Peripherial MUX for PA17 and PA16
  PORT->Group[0].PMUX[9].reg = 0x20;    // Peripherial MUX for PA19 and PA18
  PORT->Group[0].PINCFG[16].bit.PMUXEN = 1;  // Enable peripherial pin
  PORT->Group[0].PINCFG[17].bit.PMUXEN = 1;  // Enable peripherial pin
  PORT->Group[0].PINCFG[19].bit.PMUXEN = 1;  // Enable peripherial pin

  //Setting the Software Reset bit to 1
  SERCOM1->SPI.CTRLA.bit.SWRST = 1;
  //Wait both bits Software Reset from CTRLA and SYNCBUSY are equal to 0
  while(SERCOM1->SPI.CTRLA.bit.SWRST || SERCOM1->SPI.SYNCBUSY.bit.SWRST);

  // Enable clock to SERCOM1
  GCLK->CLKCTRL.reg = GCLK_CLKCTRL_ID( GCLK_CLKCTRL_ID_SERCOM1_CORE_Val ) | // Generic Clock 0 (SERCOMx)
                      GCLK_CLKCTRL_GEN_GCLK0 | // Generic Clock Generator 0 is source
                      GCLK_CLKCTRL_CLKEN ;
  PM->APBCMASK.reg |= PM_APBCMASK_SERCOM1;

  SERCOM1->SPI.CTRLA.reg = SERCOM_SPI_CTRLA_MODE_SPI_MASTER |
                           SERCOM_SPI_CTRLA_DOPO(0) |
                           SERCOM_SPI_CTRLA_DIPO(3);
  SERCOM1->SPI.CTRLA.bit.CPOL = 1;
  SERCOM1->SPI.CTRLA.bit.CPHA = 1;
  SERCOM1->SPI.CTRLB.reg = SERCOM_SPI_CTRLB_RXEN;	//Active the SPI receiver.  
  SERCOM1->SPI.BAUD.reg = 7;  // 3 MHz SPI

  SERCOM1->SPI.CTRLA.bit.ENABLE = 1;
  while(SERCOM1->SPI.SYNCBUSY.bit.ENABLE);
}

uint8_t sendFlashByte(uint8_t sendByte)
{
      SERCOM1->SPI.DATA.reg = sendByte;
      while ((SERCOM1->SPI.INTFLAG.bit.TXC == 0) || (SERCOM1->SPI.INTFLAG.bit.RXC == 0));  // Busy wait until SPI TX and RX completed
      return SERCOM1->SPI.DATA.reg;
}

uint32_t readFlash(uint32_t address)
{
  uint32_t readdata;

  PORT->Group[0].OUTCLR.reg = 1 << 18;

  sendFlashByte(0x03);
  sendFlashByte((address >> 16) & 0xFF);
  sendFlashByte((address >>  8) & 0xFF);
  sendFlashByte((address >>  0) & 0xFF);
  readdata = sendFlashByte(0xFF);
  readdata = (readdata << 8) | sendFlashByte(0xFF);
  readdata = (readdata << 8) | sendFlashByte(0xFF);
  readdata = (readdata << 8) | sendFlashByte(0xFF);

  PORT->Group[0].OUTSET.reg = 1 << 18;  // Set pin HIGH

  return readdata;
}

void sendFPGAByte(uint8_t sendByte)
{
      SERCOM3->SPI.DATA.reg = sendByte;
      while (SERCOM3->SPI.INTFLAG.bit.TXC == 0);  // Busy wait until SPI TX completed
}

void configureFPGA()
{
  uint16_t tick_sample;
  uint32_t i;
  uint32_t flashdata;

  PORT->Group[0].OUTSET.reg = 1 << 28;  // Set CONFIG_N pin HIGH
  PORT->Group[0].DIRSET.reg = 1 << 28;  // Set pin PA28 as output

  // Reset FPGA
  PORT->Group[0].OUTCLR.reg = 1 << 28;  // CONFIG_N = low
  tick_sample = jump_cnt;
  while (jump_cnt < (tick_sample + 4800));  // Wait 100 ms
  PORT->Group[0].OUTSET.reg = 1 << 28;  // Set CONFIG_N pin HIGH
  tick_sample = jump_cnt;
  while (jump_cnt < (tick_sample + 9600));  // Wait 200 ms

  // Shift out bits
  for (i=0;i<127714;i++)
  {
    flashdata = readFlash(i*4);
    sendFPGAByte((flashdata >> 24) & 0xFF);
    sendFPGAByte((flashdata >> 16) & 0xFF);
    sendFPGAByte((flashdata >> 8) & 0xFF);
    sendFPGAByte(flashdata & 0xFF);
  }
}

/**
 *  \brief SAMD21 SAM-BA Main loop.
 *  \return Unused (ANSI-C compatibility).
 */
int main(void)
{


  // TR: Set IRQ1_N pin low to signal in bootloader
  PORT->Group[0].DIRSET.reg = 1;  // Set pin PA00 as output
  PORT->Group[0].OUTCLR.reg = 1;  // Set pin PA00 LOW
  // PORT->Group[0].OUTSET.reg = 1; // Example of setting PA00 HIGH

  initFPGASPI();
  initFlashSPI();

  /* Jump in application if condition is satisfied */
  //check_start_application();

  /* We have determined we should stay in the monitor. */
  /* System initialization */
  board_init();
  __enable_irq();

#ifdef CONFIGURE_PMIC
  configure_pmic();
#endif

#ifdef ENABLE_JTAG_LOAD
  uint32_t temp ;
  // Get whole current setup for both odd and even pins and remove odd one
  temp = (PORT->Group[0].PMUX[27 >> 1].reg) & PORT_PMUX_PMUXE( 0xF ) ;
  // Set new muxing
  PORT->Group[0].PMUX[27 >> 1].reg = temp|PORT_PMUX_PMUXO( 7 ) ;
  // Enable port mux
  PORT->Group[0].PINCFG[27].reg |= PORT_PINCFG_PMUXEN ;
  clockout(0, 1);

  jtagInit();
  if ((jtagBitstreamVersion() & 0xFF000000) != 0xB0000000) {
    // FPGA is not in the bootloader, restart it
    jtagReload();    
  }
#endif

#ifdef CONFIGURE_PMIC
  if (jump_to_app == true) {
    jump_to_application();
  }
#endif

#if defined(SAM_BA_UART_ONLY)  ||  defined(SAM_BA_BOTH_INTERFACES)
  /* UART is enabled in all cases */
  serial_open();
#endif

#if defined(SAM_BA_USBCDC_ONLY)  ||  defined(SAM_BA_BOTH_INTERFACES)
  pCdc = usb_init();
#endif

  DEBUG_PIN_LOW;

  /* Initialize LEDs */
/*  LED_init();
  LEDRX_init();
  LEDRX_off();
  LEDTX_init();
  LEDTX_off(); */

  /* Start the sys tick (1 ms) */
  SysTick_Config(1000);

  // configureFPGA();

  /* Wait for a complete enum on usb or a '#' char on serial line */
  while (1)
  {
#if defined(SAM_BA_USBCDC_ONLY)  ||  defined(SAM_BA_BOTH_INTERFACES)
    if (pCdc->IsConfigured(pCdc) != 0)
    {
      main_b_cdc_enable = true;
    }

    /* Check if a USB enumeration has succeeded and if comm port has been opened */
    if (main_b_cdc_enable)
    {
      sam_ba_monitor_init(SAM_BA_INTERFACE_USBCDC);
      /* SAM-BA on USB loop */
      while( 1 )
      {
        sam_ba_monitor_run();
      }
    }
#endif

#if defined(SAM_BA_UART_ONLY)  ||  defined(SAM_BA_BOTH_INTERFACES)
    /* Check if a '#' has been received */
    if (!main_b_cdc_enable && serial_sharp_received())
    {
      sam_ba_monitor_init(SAM_BA_INTERFACE_USART);
      /* SAM-BA on Serial loop */
      while(1)
      {
        sam_ba_monitor_run();
      }
    }
    // serial_putc(0x41);
#endif

//    if (jump_on_timeout)
    if (1==0)
    {
      // check_start_application();
      jump_on_timeout = false;
      jump_on_timeout = 0;
    }

    if (start_fpga_config && !config_done)
    {
      config_done = true;
      configureFPGA();
    }

  }
}

void SysTick_Handler(void)
{
  //LED_pulse();

  sam_ba_monitor_sys_tick();
  if (jump_cnt == FPGA_CONFIG_STARTTIME_MS)
  {
    start_fpga_config = true;
  }
  jump_cnt++;
  if (jump_cnt == BOOTLOADER_WAIT_TIME_MS)
  {
    jump_on_timeout = true;
  }
}
