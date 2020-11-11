	.cpu cortex-m0plus
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 4
	.eabi_attribute 34, 0
	.file	"<artificial>"
	.text
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	serial_is_rx_ready, %function
serial_is_rx_ready:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L2
	@ sp needed
	ldrb	r0, [r3, #24]
	lsls	r0, r0, #29
	lsrs	r0, r0, #31
	bx	lr
.L3:
	.align	2
.L2:
	.word	1107298304
	.size	serial_is_rx_ready, .-serial_is_rx_ready
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	serial_getc, %function
serial_getc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
.L5:
	bl	serial_is_rx_ready
	cmp	r0, #0
	beq	.L5
	ldr	r3, .L12
	movs	r2, r3
.L6:
	ldrb	r1, [r3, #24]
	lsls	r1, r1, #29
	bpl	.L6
	ldrh	r1, [r3, #26]
	lsls	r1, r1, #31
	bmi	.L7
	ldrh	r1, [r3, #26]
	lsls	r1, r1, #30
	bmi	.L7
	ldrh	r3, [r3, #26]
.L7:
	ldrh	r0, [r2, #40]
	@ sp needed
	uxtb	r0, r0
	pop	{r4, pc}
.L13:
	.align	2
.L12:
	.word	1107298304
	.size	serial_getc, .-serial_getc
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	getbytes, %function
getbytes:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r5, #0
	movs	r6, r0
	movs	r7, r1
	movs	r4, r5
.L18:
	bl	serial_getc
	ldr	r2, .L25
	ldrb	r3, [r2]
	cmp	r3, #0
	bne	.L19
	movs	r1, #255
	lsrs	r3, r4, #8
	ands	r1, r0
	eors	r3, r1
	lsls	r1, r4, #8
	ldr	r4, .L25+4
	lsls	r3, r3, #1
	ldrh	r4, [r3, r4]
	ldrh	r3, [r2, #2]
	eors	r4, r1
	uxth	r4, r4
	cmp	r3, #0
	bne	.L16
	ldrb	r2, [r2, #4]
	cmp	r2, #0
	beq	.L17
.L16:
	strb	r0, [r6]
	adds	r6, r6, #1
	cmp	r7, #128
	bne	.L17
	ldr	r2, .L25
	subs	r3, r3, #1
	strh	r3, [r2, #2]
.L17:
	adds	r5, r5, #1
	uxth	r5, r5
	cmp	r7, r5
	bne	.L18
.L15:
	movs	r0, r4
	@ sp needed
	pop	{r3, r4, r5, r6, r7, pc}
.L19:
	movs	r4, #1
	b	.L15
.L26:
	.align	2
.L25:
	.word	.LANCHOR0
	.word	crc16Table
	.size	getbytes, .-getbytes
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	serial_getdata, %function
serial_getdata:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	movs	r4, r0
	bl	serial_getc
	@ sp needed
	strb	r0, [r4]
	movs	r0, #1
	pop	{r4, pc}
	.size	serial_getdata, .-serial_getdata
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	serial_putc, %function
serial_putc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L32
	uxtb	r0, r0
.L29:
	ldrb	r2, [r3, #24]
	lsls	r2, r2, #31
	bpl	.L29
	uxth	r0, r0
	strh	r0, [r3, #40]
	@ sp needed
	movs	r0, #1
	bx	lr
.L33:
	.align	2
.L32:
	.word	1107298304
	.size	serial_putc, .-serial_putc
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	serial_getdata_xmd, %function
serial_getdata_xmd:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #0
	push	{r4, r5, r6, r7, lr}
	ldr	r5, .L55
	sub	sp, sp, #20
	movs	r7, r0
	strb	r3, [r5]
	cmp	r1, r3
	bne	.L35
	adds	r3, r3, #1
.L53:
	movs	r4, #100
	strb	r3, [r5, #4]
.L43:
	movs	r0, #67
	bl	serial_putc
	ldr	r6, .L55+4
.L37:
	bl	serial_is_rx_ready
	cmp	r0, #0
	bne	.L38
	cmp	r6, #0
	bne	.L39
.L40:
	subs	r4, r4, #1
	cmp	r4, #0
	bne	.L43
	movs	r0, r4
	b	.L34
.L35:
	strh	r1, [r5, #2]
	b	.L53
.L39:
	subs	r6, r6, #1
	b	.L37
.L38:
	cmp	r6, #0
	beq	.L40
	movs	r6, #1
.L41:
	bl	serial_getc
	ldrb	r3, [r5]
	cmp	r3, #0
	beq	.L44
	movs	r0, #0
	strb	r0, [r5]
.L34:
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L44:
	movs	r3, #255
	ands	r0, r3
	cmp	r0, #1
	beq	.L46
	cmp	r0, #4
	beq	.L47
.L45:
	movs	r3, #0
	movs	r0, #1
	strb	r3, [r5, #4]
	b	.L34
.L46:
	movs	r1, #2
	add	r0, sp, #12
	bl	getbytes
	movs	r1, #128
	movs	r0, r7
	bl	getbytes
	str	r0, [sp, #4]
	bl	serial_getc
	lsls	r0, r0, #8
	uxth	r4, r0
	bl	serial_getc
	ldr	r3, [sp, #4]
	adds	r4, r4, r0
	uxth	r4, r4
	cmp	r3, r4
	bne	.L48
	add	r3, sp, #8
	ldrb	r3, [r3, #4]
	cmp	r3, r6
	bne	.L48
	mvns	r3, r6
	add	r2, sp, #8
	ldrb	r2, [r2, #5]
	uxtb	r3, r3
	cmp	r2, r3
	beq	.L49
.L48:
	movs	r0, #24
.L54:
	bl	serial_putc
	b	.L45
.L49:
	movs	r0, #6
	adds	r6, r6, #1
	bl	serial_putc
	uxtb	r6, r6
	adds	r7, r7, #128
	b	.L41
.L47:
	movs	r0, #6
	b	.L54
.L56:
	.align	2
.L55:
	.word	.LANCHOR0
	.word	800000
	.size	serial_getdata_xmd, .-serial_getdata_xmd
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	serial_putdata_xmd, %function
serial_putdata_xmd:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #0
	push	{r4, r5, r6, r7, lr}
	ldr	r5, .L92
	sub	sp, sp, #20
	str	r0, [sp, #12]
	movs	r4, r1
	strb	r3, [r5]
	cmp	r1, r3
	bne	.L58
	adds	r3, r3, #1
.L90:
	strb	r3, [r5, #4]
	movs	r3, #127
	tst	r4, r3
	beq	.L61
	adds	r4, r4, #128
	bics	r4, r3
.L61:
	bl	serial_getc
	ldrb	r3, [r5]
	cmp	r3, #0
	beq	.L91
	movs	r3, #0
	strb	r3, [r5]
	bl	serial_getc
.L91:
	uxtb	r0, r0
	cmp	r0, #67
	beq	.L74
	cmp	r0, #113
	beq	.L73
	cmp	r0, #21
	bne	.L61
.L74:
	movs	r3, #1
	str	r3, [sp, #4]
.L62:
	movs	r0, #1
	bl	serial_putc
	ldr	r0, [sp, #4]
	bl	serial_putc
	ldr	r3, [sp, #4]
	movs	r5, #128
	mvns	r0, r3
	movs	r7, #0
	uxtb	r0, r0
	bl	serial_putc
	ldr	r3, [sp, #12]
	str	r3, [sp, #8]
.L70:
	ldr	r2, .L92
	ldrh	r3, [r2, #2]
	cmp	r3, #0
	bne	.L68
	ldrb	r6, [r2, #4]
	cmp	r6, #0
	beq	.L69
.L68:
	ldr	r1, [sp, #8]
	subs	r3, r3, #1
	strh	r3, [r2, #2]
	movs	r3, r1
	ldrb	r6, [r1]
	adds	r3, r3, #1
	str	r3, [sp, #8]
.L69:
	movs	r0, r6
	bl	serial_putc
	lsrs	r3, r7, #8
	eors	r6, r3
	ldr	r3, .L92+4
	lsls	r6, r6, #1
	ldrh	r6, [r6, r3]
	lsls	r7, r7, #8
	eors	r6, r7
	sxth	r6, r6
	subs	r5, r5, #1
	uxth	r7, r6
	cmp	r5, #0
	bne	.L70
	lsrs	r0, r7, #8
	bl	serial_putc
	uxtb	r0, r6
	bl	serial_putc
	bl	serial_getc
	ldr	r6, .L92
	ldrb	r3, [r6]
	cmp	r3, #0
	beq	.L89
	strb	r5, [r6]
.L73:
	movs	r0, #0
	b	.L57
.L58:
	strh	r1, [r5, #2]
	b	.L90
.L89:
	movs	r3, #255
	ands	r0, r3
	cmp	r0, #6
	bne	.L66
	ldr	r3, [sp, #4]
	subs	r4, r4, #128
	adds	r3, r3, #1
	uxtb	r3, r3
	str	r3, [sp, #4]
	ldr	r3, [sp, #12]
	adds	r3, r3, #128
	str	r3, [sp, #12]
.L66:
	cmp	r4, #0
	bne	.L62
	movs	r0, #4
	bl	serial_putc
	bl	serial_getc
	movs	r0, #1
	strb	r4, [r6, #4]
.L57:
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L93:
	.align	2
.L92:
	.word	.LANCHOR0
	.word	crc16Table
	.size	serial_putdata_xmd, .-serial_putdata_xmd
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	serial_putdata, %function
serial_putdata:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	movs	r4, r0
	movs	r5, r1
	adds	r6, r0, r1
.L95:
	cmp	r4, r6
	bne	.L96
	movs	r0, r5
	@ sp needed
	pop	{r4, r5, r6, pc}
.L96:
	ldrb	r0, [r4]
	bl	serial_putc
	adds	r4, r4, #1
	b	.L95
	.size	serial_putdata, .-serial_putdata
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	sam_ba_putdata.isra.0, %function
sam_ba_putdata.isra.0:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, r0
	push	{r4, lr}
	movs	r0, r1
	movs	r1, r2
	blx	r3
	movs	r2, #100
	ldr	r3, .L98
	@ sp needed
	strh	r2, [r3, #6]
	pop	{r4, pc}
.L99:
	.align	2
.L98:
	.word	.LANCHOR0
	.size	sam_ba_putdata.isra.0, .-sam_ba_putdata.isra.0
	.thumb_set sam_ba_putdata_xmd.isra.2,sam_ba_putdata.isra.0
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	sam_ba_putdata_term, %function
sam_ba_putdata_term:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}
	ldr	r3, .L112
	movs	r2, r1
	ldrb	r1, [r3, #8]
	sub	sp, sp, #20
	ldr	r4, [r3, #12]
	cmp	r1, #0
	beq	.L101
	cmp	r2, #4
	bne	.L102
	ldr	r0, [r0]
.L103:
	movs	r6, #15
	movs	r7, #48
	lsls	r2, r2, #1
	add	r3, sp, #16
	adds	r3, r3, r2
	subs	r3, r3, #11
	subs	r5, r3, r2
.L107:
	movs	r1, r0
	ands	r1, r6
	cmp	r1, #9
	bhi	.L105
	orrs	r1, r7
.L110:
	strb	r1, [r3]
	subs	r3, r3, #1
	lsrs	r0, r0, #4
	cmp	r5, r3
	bne	.L107
	movs	r0, #10
	ldr	r3, .L112+4
	add	r1, sp, #4
	strh	r3, [r1]
	adds	r3, r1, r2
	strb	r0, [r3, #2]
	adds	r0, r0, #3
	strb	r0, [r3, #3]
	adds	r2, r2, #4
.L111:
	ldr	r0, [r4, #12]
	bl	sam_ba_putdata.isra.0
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L102:
	cmp	r2, #2
	bne	.L104
	ldrh	r0, [r0]
	b	.L103
.L104:
	ldrb	r0, [r0]
	b	.L103
.L105:
	adds	r1, r1, #55
	b	.L110
.L101:
	movs	r1, r0
	b	.L111
.L113:
	.align	2
.L112:
	.word	.LANCHOR0
	.word	30768
	.size	sam_ba_putdata_term, .-sam_ba_putdata_term
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	SysTick_Handler, %function
SysTick_Handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L125
	ldrh	r2, [r3, #6]
	cmp	r2, #0
	beq	.L115
	ldrh	r2, [r3, #6]
	subs	r2, r2, #1
	uxth	r2, r2
	strh	r2, [r3, #6]
.L115:
	ldrh	r2, [r3, #16]
	cmp	r2, #0
	beq	.L116
	ldrh	r2, [r3, #16]
	subs	r2, r2, #1
	uxth	r2, r2
	strh	r2, [r3, #16]
.L116:
	movs	r2, #150
	ldrh	r1, [r3, #18]
	lsls	r2, r2, #5
	cmp	r1, r2
	bne	.L117
	movs	r2, #1
	strb	r2, [r3, #20]
.L117:
	ldrh	r2, [r3, #18]
	adds	r2, r2, #1
	uxth	r2, r2
	strh	r2, [r3, #18]
	movs	r2, #150
	ldrh	r1, [r3, #18]
	lsls	r2, r2, #6
	cmp	r1, r2
	bne	.L114
	movs	r2, #1
	strb	r2, [r3, #21]
.L114:
	@ sp needed
	bx	lr
.L126:
	.align	2
.L125:
	.word	.LANCHOR0
	.size	SysTick_Handler, .-SysTick_Handler
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	sendFPGAByte, %function
sendFPGAByte:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L131
	str	r0, [r3, #40]
.L128:
	ldrb	r2, [r3, #24]
	lsls	r2, r2, #30
	bpl	.L128
	@ sp needed
	bx	lr
.L132:
	.align	2
.L131:
	.word	1107301376
	.size	sendFPGAByte, .-sendFPGAByte
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	sendFlashByte, %function
sendFlashByte:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L140
	str	r0, [r3, #40]
.L134:
	ldrb	r2, [r3, #24]
	lsls	r2, r2, #30
	bpl	.L134
	ldrb	r2, [r3, #24]
	lsls	r2, r2, #29
	bpl	.L134
	ldr	r0, [r3, #40]
	@ sp needed
	uxtb	r0, r0
	bx	lr
.L141:
	.align	2
.L140:
	.word	1107299328
	.size	sendFlashByte, .-sendFlashByte
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	PendSV_Handler, %function
PendSV_Handler:
	@ Volatile: function does not return.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	.syntax divided
@ 139 "board_startup.c" 1
	bkpt 2
@ 0 "" 2
	.thumb
	.syntax unified
.L143:
	b	.L143
	.size	PendSV_Handler, .-PendSV_Handler
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	SVC_Handler, %function
SVC_Handler:
	@ Volatile: function does not return.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	.syntax divided
@ 133 "board_startup.c" 1
	bkpt 5
@ 0 "" 2
	.thumb
	.syntax unified
.L145:
	b	.L145
	.size	SVC_Handler, .-SVC_Handler
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	HardFault_Handler, %function
HardFault_Handler:
	@ Volatile: function does not return.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	.syntax divided
@ 127 "board_startup.c" 1
	bkpt 13
@ 0 "" 2
	.thumb
	.syntax unified
.L147:
	b	.L147
	.size	HardFault_Handler, .-HardFault_Handler
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	NMI_Handler, %function
NMI_Handler:
	@ Volatile: function does not return.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	.syntax divided
@ 121 "board_startup.c" 1
	bkpt 14
@ 0 "" 2
	.thumb
	.syntax unified
.L149:
	b	.L149
	.size	NMI_Handler, .-NMI_Handler
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	dfll_sync, %function
dfll_sync:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r3, #16
	ldr	r1, .L154
.L151:
	ldr	r2, [r1, #12]
	tst	r2, r3
	beq	.L151
	@ sp needed
	bx	lr
.L155:
	.align	2
.L154:
	.word	1073743872
	.size	dfll_sync, .-dfll_sync
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	gclk_sync, %function
gclk_sync:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L159
.L157:
	ldrb	r3, [r2, #1]
	sxtb	r3, r3
	cmp	r3, #0
	blt	.L157
	@ sp needed
	bx	lr
.L160:
	.align	2
.L159:
	.word	1073744896
	.size	gclk_sync, .-gclk_sync
	.section	.text.startup,"ax",%progbits
	.align	1
	.global	main
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	main, %function
main:
	@ Volatile: function does not return.
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 1, uses_anonymous_args = 0
	movs	r2, #1
	movs	r0, #34
	ldr	r1, .L297
	ldr	r3, .L297+4
	push	{r4, r5, r6, r7, lr}
	str	r2, [r1, #8]
	str	r2, [r1, #20]
	strb	r0, [r3]
	ldr	r0, .L297+8
	sub	sp, sp, #60
	ldrb	r3, [r0]
	add	r7, sp, #0
	orrs	r3, r2
	strb	r3, [r0]
	ldr	r0, .L297+12
	ldrb	r3, [r0]
	orrs	r3, r2
	strb	r3, [r0]
	ldr	r3, .L297+16
	ldr	r0, [r3]
	orrs	r2, r0
	str	r2, [r3]
	movs	r2, r1
.L162:
	ldr	r1, [r3]
	lsls	r1, r1, #31
	bmi	.L162
	ldr	r1, [r3, #28]
	lsls	r1, r1, #31
	bmi	.L162
	ldr	r1, .L297+20
	ldr	r4, .L297+24
	ldr	r0, .L297+28
	strh	r1, [r4, #2]
	movs	r1, #32
	ldr	r5, [r0, #32]
	ldr	r6, .L297+32
	orrs	r1, r5
	str	r1, [r0, #32]
	ldr	r1, .L297+36
	str	r1, [r3]
	ldr	r5, [r3]
	ands	r5, r6
	str	r5, [r3]
	ldr	r5, [r3]
	ldr	r6, .L297+40
	ands	r5, r6
	str	r5, [r3]
	movs	r5, #128
	lsls	r5, r5, #10
	str	r5, [r3, #4]
	movs	r5, #7
	strb	r5, [r3, #12]
	ldr	r6, [r3]
	subs	r5, r5, #5
	orrs	r5, r6
	str	r5, [r3]
	str	r0, [r7, #12]
.L164:
	ldr	r0, [r3, #28]
	lsls	r0, r0, #30
	bmi	.L164
	movs	r3, #128
	lsls	r3, r3, #11
	str	r3, [r2, #24]
	str	r3, [r2, #8]
	movs	r2, #34
	ldr	r3, .L297+44
	ldr	r0, .L297+48
	strb	r2, [r3]
	ldr	r3, .L297+52
	subs	r2, r2, #2
	strb	r2, [r3]
	ldrb	r3, [r0]
	subs	r2, r2, #31
	orrs	r3, r2
	strb	r3, [r0]
	ldr	r0, .L297+56
	ldrb	r3, [r0]
	orrs	r3, r2
	strb	r3, [r0]
	ldr	r0, .L297+60
	ldrb	r3, [r0]
	orrs	r3, r2
	strb	r3, [r0]
	ldr	r3, .L297+64
	ldr	r0, [r3]
	orrs	r2, r0
	str	r2, [r3]
.L165:
	ldr	r2, [r3]
	lsls	r2, r2, #31
	bmi	.L165
	ldr	r2, [r3, #28]
	lsls	r2, r2, #31
	bmi	.L165
	ldr	r2, .L297+68
	strh	r2, [r4, #2]
	ldr	r2, [r7, #12]
	ldr	r0, [r2, #32]
	movs	r2, #8
	orrs	r2, r0
	ldr	r0, [r7, #12]
	str	r2, [r0, #32]
	movs	r2, #128
	str	r1, [r3]
	ldr	r1, [r3]
	lsls	r2, r2, #22
	orrs	r2, r1
	str	r2, [r3]
	movs	r2, #128
	ldr	r1, [r3]
	lsls	r2, r2, #21
	orrs	r2, r1
	str	r2, [r3]
	movs	r2, #128
	lsls	r2, r2, #10
	str	r2, [r3, #4]
	movs	r2, #7
	strb	r2, [r3, #12]
	ldr	r1, [r3]
	subs	r2, r2, #5
	orrs	r2, r1
	str	r2, [r3]
.L167:
	ldr	r2, [r3, #28]
	lsls	r2, r2, #30
	bmi	.L167
	movs	r2, #30
	ldr	r6, .L297+72
	ldr	r5, .L297+76
	ldr	r3, [r6, #4]
	bics	r3, r2
	subs	r2, r2, #28
	orrs	r3, r2
	str	r3, [r6, #4]
	str	r2, [r4, #8]
	bl	gclk_sync
	ldr	r3, .L297+80
	str	r3, [r4, #4]
	bl	gclk_sync
	movs	r2, #2
	strh	r2, [r5, #36]
	bl	dfll_sync
	ldr	r3, .L297+84
	ldr	r3, [r3]
	str	r6, [r7, #8]
	lsrs	r3, r3, #26
	cmp	r3, #63
	bne	.L168
	subs	r3, r3, #32
.L168:
	ldr	r2, .L297+88
	lsls	r3, r3, #10
	orrs	r3, r2
	ldr	r2, .L297+92
	movs	r6, #2
	str	r2, [r5, #44]
	str	r3, [r5, #40]
	movs	r3, #0
	strh	r3, [r5, #36]
	bl	dfll_sync
	ldr	r3, .L297+96
	strh	r3, [r5, #36]
	bl	dfll_sync
	ldrh	r3, [r5, #36]
	orrs	r3, r6
	strh	r3, [r5, #36]
	bl	dfll_sync
	movs	r2, #63
	ldrh	r3, [r4, #2]
	movs	r5, #0
	bics	r3, r2
	movs	r2, #128
	orrs	r6, r3
	strh	r6, [r4, #2]
	ldrh	r3, [r4, #2]
	lsls	r2, r2, #7
	orrs	r3, r2
	strh	r3, [r4, #2]
	str	r5, [r4, #8]
	bl	gclk_sync
	ldr	r3, .L297+100
	str	r3, [r4, #4]
	bl	gclk_sync
	movs	r0, #192
	ldr	r3, .L297+104
	ldr	r2, .L297+108
	ldr	r1, .L297+112
	str	r2, [r3, #4]
	mov	ip, r2
	ldr	r2, [r1, #32]
	lsls	r0, r0, #24
	lsls	r2, r2, #8
	lsrs	r2, r2, #8
	orrs	r2, r0
	str	r2, [r1, #32]
	movs	r2, #7
	str	r5, [r3, #8]
	str	r2, [r3]
	.syntax divided
@ 60 "/root/.arduino15/packages/arduino/tools/CMSIS/4.5.0/CMSIS/Include/cmsis_gcc.h" 1
	cpsie i
@ 0 "" 2
	.thumb
	.syntax unified
	movs	r6, #1
	movs	r0, #15
	ldr	r5, .L297+116
	ldrb	r2, [r5]
	orrs	r2, r6
	strb	r2, [r5]
	ldr	r2, .L297+120
	ldrb	r5, [r2]
	bics	r5, r0
	strb	r5, [r2]
	ldrb	r5, [r2]
	movs	r0, r5
	movs	r5, #3
	orrs	r5, r0
	strb	r5, [r2]
	ldr	r5, .L297+124
	ldrb	r0, [r5]
	orrs	r0, r6
	strb	r0, [r5]
	ldrb	r0, [r2]
	adds	r6, r6, #14
	ands	r6, r0
	movs	r0, #48
	strb	r6, [r2]
	ldrb	r5, [r2]
	orrs	r0, r5
	strb	r0, [r2]
	ldr	r2, [r7, #12]
	mov	r5, ip
	ldr	r0, [r2, #32]
	movs	r2, #4
	orrs	r2, r0
	ldr	r0, [r7, #12]
	str	r2, [r0, #32]
	ldr	r2, .L297+128
	strh	r2, [r4, #2]
.L169:
	ldrb	r2, [r4, #1]
	sxtb	r2, r2
	cmp	r2, #0
	blt	.L169
	ldr	r0, .L297+132
	movs	r2, r0
.L170:
	ldr	r4, [r0, #28]
	lsls	r4, r4, #30
	bmi	.L170
	movs	r6, #2
	ldr	r4, [r0]
	bics	r4, r6
	str	r4, [r0]
.L171:
	ldr	r0, [r2, #28]
	lsls	r0, r0, #31
	bmi	.L171
	movs	r0, #1
	ldr	r4, [r2]
	orrs	r0, r4
	str	r0, [r2]
.L172:
	ldr	r0, [r2]
	lsls	r0, r0, #31
	bmi	.L172
.L173:
	ldr	r0, [r2, #28]
	lsls	r0, r0, #31
	bmi	.L173
	ldr	r0, [r2, #28]
	lsls	r0, r0, #30
	bmi	.L173
	ldr	r0, .L297+136
	str	r0, [r2]
.L175:
	ldr	r0, [r2, #28]
	lsls	r0, r0, #29
	bmi	.L175
	movs	r0, #192
	lsls	r0, r0, #10
	str	r0, [r2, #4]
	ldr	r0, .L297+140
	strh	r0, [r2, #12]
.L176:
	ldr	r0, [r2, #28]
	lsls	r0, r0, #30
	lsrs	r0, r0, #31
	bne	.L176
	movs	r4, #2
	ldr	r6, [r2]
	orrs	r4, r6
	str	r4, [r2]
	ldr	r4, .L297+144
	strb	r0, [r4, #22]
	strb	r0, [r4]
	strb	r0, [r4, #23]
	strb	r0, [r4, #24]
	strb	r0, [r4, #25]
	strb	r0, [r4, #26]
	str	r5, [r3, #4]
	movs	r5, #192
	ldr	r2, [r1, #32]
	lsls	r5, r5, #24
	lsls	r2, r2, #8
	lsrs	r2, r2, #8
	orrs	r2, r5
	str	r2, [r1, #32]
	movs	r2, #7
	str	r0, [r3, #8]
	str	r2, [r3]
.L177:
	ldrb	r5, [r4, #27]
	uxtb	r5, r5
	cmp	r5, #0
	beq	.LCB1255
	b	.L178	@long jump
.LCB1255:
	bl	serial_is_rx_ready
	cmp	r0, #0
	bne	.LCB1258
	b	.L178	@long jump
.LCB1258:
	bl	serial_getc
	cmp	r0, #35
	beq	.LCB1261
	b	.L178	@long jump
.LCB1261:
	ldr	r3, .L297+148
	movs	r2, #16
	str	r3, [r4, #12]
	movs	r3, #1
	adds	r2, r7, r2
	strb	r3, [r4, #28]
	adds	r3, r3, #7
	adds	r3, r2, r3
	mov	ip, r3
	mov	r2, ip
	ldr	r3, .L297+148
	adds	r3, r3, #28
	ldmia	r3!, {r0, r1, r6}
	stmia	r2!, {r0, r1, r6}
	ldmia	r3!, {r0, r1, r6}
	stmia	r2!, {r0, r1, r6}
	ldmia	r3!, {r0, r1}
	stmia	r2!, {r0, r1}
	mov	r2, ip
	ldr	r3, [r7, #8]
	ldr	r3, [r3, #8]
	lsls	r3, r3, #13
	lsrs	r3, r3, #29
	lsls	r3, r3, #2
	ldr	r3, [r3, r2]
	ldr	r2, [r7, #8]
	str	r3, [r4, #32]
	ldr	r2, [r2, #8]
	str	r5, [r4, #40]
	uxth	r2, r2
	muls	r3, r2
	str	r3, [r4, #36]
	movs	r3, r4
	movs	r2, #122
	adds	r3, r3, #44
	strb	r2, [r3]
.L237:
	ldr	r3, [r4, #12]
	movs	r1, #64
	ldr	r3, [r3, #16]
	ldr	r0, .L297+152
	blx	r3
	cmp	r0, #0
	beq	.L179
	movs	r3, #100
	strh	r3, [r4, #16]
.L179:
	ldr	r3, .L297+152
	str	r0, [r4, #112]
	str	r3, [r4, #116]
	movs	r3, #0
	str	r3, [r4, #120]
.L180:
	ldr	r3, [r4, #120]
	ldr	r2, [r4, #112]
	cmp	r3, r2
	bcs	.L237
	ldr	r3, [r4, #116]
	ldrb	r3, [r3]
	cmp	r3, #255
	bne	.LCB1331
	b	.L182	@long jump
.LCB1331:
	cmp	r3, #35
	beq	.LCB1333
	b	.L183	@long jump
.LCB1333:
	ldrb	r3, [r4, #8]
	cmp	r3, #0
	beq	.L184
	ldr	r3, [r4, #12]
	movs	r2, #2
	ldr	r1, .L297+156
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
.L184:
	movs	r0, r4
	adds	r0, r0, #44
	ldrb	r3, [r0]
	cmp	r3, #83
	beq	.LCB1349
	b	.L185	@long jump
.LCB1349:
	ldr	r3, [r4, #112]
	ldr	r5, [r4, #120]
	cmp	r3, r5
	bls	.L186
	ldr	r1, [r4, #116]
	ldr	r2, [r4, #124]
	adds	r1, r1, #1
	adds	r5, r5, #1
	str	r1, [r7, #8]
	str	r1, [r4, #116]
	str	r5, [r4, #120]
	subs	r3, r3, r5
	ldr	r6, .L297+160
	cmp	r2, r3
	bhi	.LCB1365
	b	.L187	@long jump
.LCB1365:
	str	r3, [r6]
.L188:
	ldr	r3, [r6]
	ldr	r1, [r7, #8]
	movs	r2, r3
	ldr	r0, [r4, #40]
	str	r3, [r7, #12]
	bl	memcpy
	ldr	r2, [r7, #12]
	ldr	r3, [r7, #12]
	mov	ip, r2
	adds	r5, r5, r3
	ldr	r3, [r7, #8]
	str	r5, [r4, #120]
	add	r3, r3, ip
	str	r3, [r4, #116]
	ldrb	r3, [r7, #12]
	strb	r3, [r6, #4]
.L186:
	ldr	r3, [r4, #120]
	ldr	r1, [r4, #124]
	subs	r3, r3, #1
	str	r3, [r4, #120]
	ldr	r3, [r4, #116]
	subs	r3, r3, #1
	str	r3, [r4, #116]
	ldr	r3, .L297+160
	ldrb	r3, [r3, #4]
	cmp	r3, r1
	bcs	.L190
	subs	r1, r1, r3
	ldr	r3, [r4, #12]
	ldr	r0, [r4, #40]
	ldr	r3, [r3, #24]
	blx	r3
	cmp	r0, #0
	beq	.L190
	movs	r3, #100
	strh	r3, [r4, #16]
.L190:
	.syntax divided
@ 319 "sam_ba_monitor.c" 1
	nop
@ 0 "" 2
	.thumb
	.syntax unified
	b	.L298
.L299:
	.align	2
.L297:
	.word	1090536448
	.word	1090536507
	.word	1090536534
	.word	1090536535
	.word	1107301376
	.word	16407
	.word	1073744896
	.word	1073742848
	.word	-536870913
	.word	3145740
	.word	-268435457
	.word	1090536504
	.word	1090536528
	.word	1090536505
	.word	1090536529
	.word	1090536531
	.word	1107299328
	.word	16405
	.word	1090535424
	.word	1073743872
	.word	65542
	.word	8413220
	.word	511
	.word	470465408
	.word	1316
	.word	198400
	.word	-536813552
	.word	999
	.word	-536810240
	.word	1090536518
	.word	1090536499
	.word	1090536519
	.word	16404
	.word	1107298304
	.word	1076953092
	.word	-2518
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	.LANCHOR0+45
	.word	.LC15
	.word	.LANCHOR2
.L298:
.L192:
	movs	r3, r4
	movs	r2, #122
	adds	r3, r3, #44
	strb	r2, [r3]
	movs	r3, #0
	str	r3, [r4, #124]
	ldrb	r3, [r4, #8]
	cmp	r3, #0
	beq	.L182
	ldr	r3, [r4, #12]
	movs	r2, #1
	ldr	r1, .L300
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
.L182:
	ldr	r3, [r4, #120]
	adds	r3, r3, #1
	str	r3, [r4, #120]
	ldr	r3, [r4, #116]
	adds	r3, r3, #1
	str	r3, [r4, #116]
	b	.L180
.L187:
	str	r2, [r6]
	b	.L188
.L185:
	cmp	r3, #82
	bne	.L193
	ldr	r3, [r4, #12]
	ldr	r2, [r4, #124]
	ldr	r1, [r4, #40]
	ldr	r0, [r3, #20]
	bl	sam_ba_putdata_xmd.isra.2
	b	.L192
.L193:
	cmp	r3, #79
	bne	.L194
	ldr	r3, [r4, #124]
	ldr	r2, [r4, #40]
	strb	r3, [r2]
	b	.L192
.L194:
	cmp	r3, #72
	bne	.L195
	ldr	r3, [r4, #124]
	ldr	r2, [r4, #40]
	strh	r3, [r2]
	b	.L192
.L195:
	cmp	r3, #87
	bne	.L196
	ldr	r3, [r4, #40]
	ldr	r2, [r4, #124]
	str	r2, [r3]
	b	.L192
.L196:
	cmp	r3, #111
	bne	.L197
	movs	r1, #1
	ldr	r0, [r4, #40]
.L292:
	bl	sam_ba_putdata_term
	b	.L192
.L197:
	cmp	r3, #104
	bne	.L198
	ldr	r3, [r4, #40]
	adds	r0, r0, #80
	ldrh	r3, [r3]
	movs	r1, #2
	str	r3, [r4, #124]
	b	.L292
.L198:
	cmp	r3, #119
	bne	.L199
	ldr	r3, [r4, #40]
	adds	r0, r0, #80
	ldr	r3, [r3]
	movs	r1, #4
	str	r3, [r4, #124]
	b	.L292
.L199:
	cmp	r3, #71
	bne	.L200
	ldr	r1, [r4, #124]
	.syntax divided
@ 71 "/root/.arduino15/packages/arduino/tools/CMSIS/4.5.0/CMSIS/Include/cmsis_gcc.h" 1
	cpsid i
@ 0 "" 2
@ 177 "/root/.arduino15/packages/arduino/tools/CMSIS/4.5.0/CMSIS/Include/cmsis_gcc.h" 1
	MRS r3, msp

@ 0 "" 2
	.thumb
	.syntax unified
	ldr	r2, .L300+4
	str	r3, [r2, #8]
	ldr	r3, [r1]
	.syntax divided
@ 190 "/root/.arduino15/packages/arduino/tools/CMSIS/4.5.0/CMSIS/Include/cmsis_gcc.h" 1
	MSR msp, r3

@ 0 "" 2
	.thumb
	.syntax unified
	ldr	r3, [r1, #4]
	.syntax divided
@ 241 "sam_ba_monitor.c" 1
	bx r3
@ 0 "" 2
	.thumb
	.syntax unified
	ldr	r3, [r2, #8]
	.syntax divided
@ 190 "/root/.arduino15/packages/arduino/tools/CMSIS/4.5.0/CMSIS/Include/cmsis_gcc.h" 1
	MSR msp, r3

@ 0 "" 2
@ 60 "/root/.arduino15/packages/arduino/tools/CMSIS/4.5.0/CMSIS/Include/cmsis_gcc.h" 1
	cpsie i
@ 0 "" 2
	.thumb
	.syntax unified
	ldrb	r3, [r4, #28]
	cmp	r3, #0
	beq	.L192
	ldr	r3, [r4, #12]
	movs	r0, #6
	ldr	r3, [r3]
	blx	r3
	b	.L192
.L200:
	cmp	r3, #84
	bne	.L202
	subs	r3, r3, #83
	strb	r3, [r4, #8]
.L296:
	movs	r2, #2
	ldr	r3, [r4, #12]
	ldr	r1, .L300+8
.L293:
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
	b	.L192
.L202:
	cmp	r3, #78
	bne	.L203
	ldrb	r3, [r4, #8]
	cmp	r3, #0
	bne	.L204
	ldr	r3, [r4, #12]
	movs	r2, #2
	ldr	r1, .L300+8
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
.L204:
	movs	r3, #0
	strb	r3, [r4, #8]
	b	.L192
.L203:
	cmp	r3, #86
	bne	.L205
	ldr	r3, [r4, #12]
	movs	r2, #1
	ldr	r1, .L300+12
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
	ldr	r3, [r4, #12]
	ldr	r1, .L300+16
	movs	r2, #3
	adds	r1, r1, #60
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
	ldr	r5, .L300+20
	ldr	r3, [r4, #12]
	movs	r2, #1
	movs	r1, r5
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
	ldr	r3, [r4, #12]
	ldr	r1, .L300+16
	movs	r2, #13
	adds	r1, r1, #64
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
	ldr	r3, [r4, #12]
	movs	r2, #1
	movs	r1, r5
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
	movs	r3, #0
	movs	r0, #1
	movs	r2, r3
	mov	ip, r0
	ldr	r1, .L300+24
	str	r3, [r4, #120]
	str	r1, [r4, #116]
.L206:
	adds	r6, r3, #1
	ldr	r0, .L300+28
	str	r6, [r7, #12]
	ldrb	r6, [r1, r3]
	adds	r0, r0, r3
	cmp	r6, #0
	bne	.L243
	cmp	r2, #0
	beq	.L207
	str	r3, [r4, #120]
.L207:
	ldr	r3, [r4, #12]
	str	r0, [r4, #116]
	ldr	r2, [r4, #120]
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
	ldr	r3, [r4, #12]
	movs	r2, #1
	movs	r1, r5
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
	movs	r3, #0
	movs	r2, r3
	ldr	r1, .L300+32
	str	r3, [r4, #120]
	adds	r6, r1, #1
.L208:
	ldrb	r5, [r1, r2]
	adds	r0, r6, r2
	cmp	r5, #0
	bne	.L209
	cmp	r3, #0
	beq	.L210
	str	r2, [r4, #120]
.L210:
	ldr	r3, [r4, #12]
	str	r0, [r4, #116]
	ldr	r2, [r4, #120]
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
	b	.L296
.L243:
	ldr	r3, [r7, #12]
	mov	r2, ip
	b	.L206
.L209:
	adds	r2, r2, #1
	movs	r3, #1
	b	.L208
.L205:
	cmp	r3, #88
	bne	.L211
	ldr	r2, [r4, #32]
	ldr	r3, [r4, #124]
	ldr	r0, [r4, #36]
	ldr	r1, .L300+36
	ldr	r5, .L300+40
	lsls	r2, r2, #2
.L212:
	cmp	r3, r0
	bcc	.L214
	ldr	r3, [r4, #12]
	movs	r2, #3
	ldr	r1, .L300+44
	b	.L293
.L214:
	lsrs	r6, r3, #1
	str	r6, [r1, #28]
	strh	r5, [r1]
.L213:
	ldrb	r6, [r1, #20]
	lsls	r6, r6, #31
	bpl	.L213
	adds	r3, r3, r2
	b	.L212
.L211:
	cmp	r3, #89
	bne	.L215
	ldr	r2, [r4, #124]
	ldr	r0, [r4, #40]
	ldr	r3, .L300+4
	cmp	r2, #0
	bne	.L216
	str	r0, [r3, #12]
.L217:
	ldr	r3, [r4, #12]
	movs	r2, #3
	ldr	r1, .L300+48
	b	.L293
.L216:
	movs	r5, #128
	ldr	r3, [r3, #12]
	lsrs	r2, r2, #2
	str	r3, [r7, #8]
	ldr	r3, .L300+36
	ldr	r1, [r3, #4]
	bics	r1, r5
	str	r1, [r3, #4]
	ldr	r1, [r4, #32]
	lsrs	r1, r1, #2
	str	r1, [r7, #4]
	ldr	r1, .L300+52
	mov	ip, r1
.L218:
	cmp	r2, #0
	beq	.L217
	ldr	r1, .L300+56
	strh	r1, [r3]
.L219:
	ldrb	r1, [r3, #20]
	lsls	r1, r1, #31
	bpl	.L219
	movs	r1, #0
	ldr	r6, [r7, #8]
	str	r0, [r7, #12]
.L220:
	ldr	r5, [r7, #4]
	ldr	r0, [r7, #12]
	str	r6, [r7, #8]
	cmp	r1, r5
	beq	.L221
	cmp	r1, r2
	bne	.L222
.L221:
	mov	r5, ip
	strh	r5, [r3]
.L223:
	ldrb	r5, [r3, #20]
	lsls	r5, r5, #31
	bpl	.L223
	subs	r2, r2, r1
	b	.L218
.L222:
	ldr	r5, [r7, #12]
	ldmia	r6!, {r0}
	adds	r1, r1, #1
	stmia	r5!, {r0}
	str	r5, [r7, #12]
	b	.L220
.L215:
	cmp	r3, #90
	beq	.LCB1860
	b	.L192	@long jump
.LCB1860:
	movs	r5, #0
	ldr	r3, [r4, #40]
	ldr	r2, [r4, #124]
	ldr	r0, .L300+60
	adds	r1, r3, r2
.L226:
	cmp	r1, r3
	bne	.L227
	ldr	r3, [r4, #12]
	movs	r2, #1
	ldr	r0, [r3, #12]
	ldr	r1, .L300+64
	bl	sam_ba_putdata.isra.0
	movs	r3, #7
.L230:
	movs	r2, #15
	ands	r2, r5
	uxtb	r0, r2
	movs	r1, r0
	lsrs	r5, r5, #4
	adds	r1, r1, #48
	cmp	r2, #9
	ble	.L229
	adds	r1, r1, #7
.L229:
	movs	r2, #16
	adds	r2, r7, r2
	strb	r1, [r2, r3]
	subs	r3, r3, #1
	bcs	.L230
	movs	r1, #16
	ldr	r5, .L300+68
	movs	r2, #8
	ldr	r3, [r5, #12]
	adds	r1, r7, r1
	ldr	r0, [r3, #12]
	bl	sam_ba_putdata.isra.0
	ldr	r3, [r5, #12]
	movs	r2, #3
	ldr	r1, .L300+72
	b	.L293
.L227:
	ldrb	r6, [r3]
	lsrs	r2, r5, #8
	eors	r2, r6
	lsls	r2, r2, #1
	ldrh	r2, [r2, r0]
	lsls	r5, r5, #8
	eors	r5, r2
	uxth	r5, r5
	adds	r3, r3, #1
	b	.L226
.L183:
	movs	r2, r3
	subs	r2, r2, #48
	uxtb	r1, r2
	cmp	r1, #9
	bhi	.L232
	ldr	r3, [r4, #124]
	lsls	r3, r3, #4
.L294:
	orrs	r3, r2
	str	r3, [r4, #124]
	b	.L182
.L232:
	movs	r2, r3
	subs	r2, r2, #65
	cmp	r2, #5
	bhi	.L233
	ldr	r2, [r4, #124]
	subs	r3, r3, #55
	lsls	r2, r2, #4
	b	.L294
.L233:
	movs	r2, r3
	subs	r2, r2, #97
	cmp	r2, #5
	bhi	.L234
	ldr	r2, [r4, #124]
	subs	r3, r3, #87
	lsls	r2, r2, #4
	b	.L294
.L234:
	movs	r2, #0
	cmp	r3, #44
	bne	.L235
	ldr	r3, [r4, #124]
	str	r3, [r4, #40]
.L295:
	str	r2, [r4, #124]
	b	.L182
.L235:
	movs	r1, r4
	adds	r1, r1, #44
	strb	r3, [r1]
	b	.L295
.L301:
	.align	2
.L300:
	.word	.LC35
	.word	.LANCHOR2
	.word	.LC15
	.word	.LC18
	.word	.LANCHOR1
	.word	.LC20
	.word	.LC22
	.word	.LC22+1
	.word	.LC24
	.word	1090535424
	.word	-23294
	.word	.LC26
	.word	.LC28
	.word	-23292
	.word	-23228
	.word	crc16Table
	.word	.LC31
	.word	.LANCHOR0
	.word	.LC33
.L178:
	ldrb	r3, [r4, #20]
	cmp	r3, #0
	bne	.LCB2017
	b	.L177	@long jump
.LCB2017:
	ldr	r5, .L302
	ldrb	r3, [r5, #16]
	cmp	r3, #0
	beq	.LCB2022
	b	.L177	@long jump
.LCB2022:
	movs	r2, #128
	adds	r3, r3, #1
	strb	r3, [r5, #16]
	ldr	r3, .L302+4
	lsls	r2, r2, #21
	str	r2, [r3, #24]
	str	r2, [r3, #8]
	str	r2, [r3, #20]
	ldrh	r2, [r4, #18]
	ldr	r1, .L302+8
	adds	r2, r2, r1
.L239:
	ldrh	r1, [r4, #18]
	cmp	r2, r1
	bge	.L239
	movs	r2, #128
	lsls	r2, r2, #21
	str	r2, [r3, #24]
	ldrh	r3, [r4, #18]
	ldr	r2, .L302+12
	adds	r3, r3, r2
.L240:
	ldrh	r2, [r4, #18]
	cmp	r3, r2
	bge	.L240
	movs	r6, #0
.L241:
	movs	r2, #128
	ldr	r3, .L302+4
	lsls	r2, r2, #11
	str	r2, [r3, #20]
	movs	r0, #3
	bl	sendFlashByte
	lsrs	r0, r6, #16
	uxtb	r0, r0
	bl	sendFlashByte
	lsrs	r0, r6, #8
	uxtb	r0, r0
	bl	sendFlashByte
	uxtb	r0, r6
	bl	sendFlashByte
	movs	r0, #255
	bl	sendFlashByte
	str	r0, [r5, #20]
	ldr	r1, [r5, #20]
	movs	r0, #255
	str	r1, [r7, #12]
	bl	sendFlashByte
	ldr	r1, [r7, #12]
	adds	r6, r6, #4
	lsls	r1, r1, #8
	orrs	r0, r1
	str	r0, [r5, #20]
	ldr	r1, [r5, #20]
	movs	r0, #255
	str	r1, [r7, #12]
	bl	sendFlashByte
	ldr	r1, [r7, #12]
	lsls	r1, r1, #8
	orrs	r0, r1
	str	r0, [r5, #20]
	ldr	r1, [r5, #20]
	movs	r0, #255
	str	r1, [r7, #12]
	bl	sendFlashByte
	movs	r2, #128
	ldr	r1, [r7, #12]
	ldr	r3, .L302+4
	lsls	r1, r1, #8
	orrs	r0, r1
	lsls	r2, r2, #11
	str	r0, [r5, #20]
	str	r2, [r3, #24]
	ldr	r0, [r5, #20]
	lsrs	r0, r0, #24
	bl	sendFPGAByte
	ldr	r0, [r5, #20]
	lsrs	r0, r0, #16
	uxtb	r0, r0
	bl	sendFPGAByte
	ldr	r0, [r5, #20]
	lsrs	r0, r0, #8
	uxtb	r0, r0
	bl	sendFPGAByte
	ldr	r0, [r5, #20]
	uxtb	r0, r0
	bl	sendFPGAByte
	ldr	r3, .L302+16
	cmp	r6, r3
	bne	.L241
	b	.L177
.L303:
	.align	2
.L302:
	.word	.LANCHOR2
	.word	1090536448
	.word	4799
	.word	9599
	.word	510856
	.size	main, .-main
	.text
	.align	1
	.global	Reset_Handler
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	Reset_Handler, %function
Reset_Handler:
	@ Volatile: function does not return.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L316
	ldr	r0, .L316+4
	push	{r4, r5, r6, lr}
	cmp	r2, r0
	bne	.L305
.L309:
	ldr	r2, .L316+8
	ldr	r3, .L316+12
	movs	r1, #0
	cmp	r3, r2
	bne	.L306
.L307:
	bl	main
.L305:
	ldr	r4, .L316+16
	movs	r3, #0
	cmp	r4, r2
	beq	.L309
.L308:
	adds	r1, r2, r3
	cmp	r0, r1
	bls	.L309
	ldr	r5, [r4, r3]
	adds	r3, r3, #4
	str	r5, [r1]
	b	.L308
.L311:
	stmia	r3!, {r1}
.L306:
	cmp	r3, r2
	bcc	.L311
	b	.L307
.L317:
	.align	2
.L316:
	.word	__data_start__
	.word	__data_end__
	.word	__bss_end__
	.word	__bss_start__
	.word	__etext
	.size	Reset_Handler, .-Reset_Handler
	.global	exception_table
	.section	.rodata
	.align	2
	.set	.LANCHOR1,. + 0
	.type	uart_if, %object
	.size	uart_if, 28
uart_if:
	.word	serial_putc
	.word	serial_getc
	.word	serial_is_rx_ready
	.word	serial_putdata
	.word	serial_getdata
	.word	serial_putdata_xmd
	.word	serial_getdata_xmd
.LC14:
	.word	8
	.word	16
	.word	32
	.word	64
	.word	128
	.word	256
	.word	512
	.word	1024
	.type	RomBOOT_Version, %object
	.size	RomBOOT_Version, 4
RomBOOT_Version:
	.ascii	"2.0\000"
	.type	RomBOOT_ExtendedCapabilities, %object
	.size	RomBOOT_ExtendedCapabilities, 14
RomBOOT_ExtendedCapabilities:
	.ascii	"[Arduino:XYZ]\000"
	.type	crc16Table, %object
	.size	crc16Table, 512
crc16Table:
	.short	0
	.short	4129
	.short	8258
	.short	12387
	.short	16516
	.short	20645
	.short	24774
	.short	28903
	.short	-32504
	.short	-28375
	.short	-24246
	.short	-20117
	.short	-15988
	.short	-11859
	.short	-7730
	.short	-3601
	.short	4657
	.short	528
	.short	12915
	.short	8786
	.short	21173
	.short	17044
	.short	29431
	.short	25302
	.short	-27847
	.short	-31976
	.short	-19589
	.short	-23718
	.short	-11331
	.short	-15460
	.short	-3073
	.short	-7202
	.short	9314
	.short	13379
	.short	1056
	.short	5121
	.short	25830
	.short	29895
	.short	17572
	.short	21637
	.short	-23190
	.short	-19125
	.short	-31448
	.short	-27383
	.short	-6674
	.short	-2609
	.short	-14932
	.short	-10867
	.short	13907
	.short	9842
	.short	5649
	.short	1584
	.short	30423
	.short	26358
	.short	22165
	.short	18100
	.short	-18597
	.short	-22662
	.short	-26855
	.short	-30920
	.short	-2081
	.short	-6146
	.short	-10339
	.short	-14404
	.short	18628
	.short	22757
	.short	26758
	.short	30887
	.short	2112
	.short	6241
	.short	10242
	.short	14371
	.short	-13876
	.short	-9747
	.short	-5746
	.short	-1617
	.short	-30392
	.short	-26263
	.short	-22262
	.short	-18133
	.short	23285
	.short	19156
	.short	31415
	.short	27286
	.short	6769
	.short	2640
	.short	14899
	.short	10770
	.short	-9219
	.short	-13348
	.short	-1089
	.short	-5218
	.short	-25735
	.short	-29864
	.short	-17605
	.short	-21734
	.short	27814
	.short	31879
	.short	19684
	.short	23749
	.short	11298
	.short	15363
	.short	3168
	.short	7233
	.short	-4690
	.short	-625
	.short	-12820
	.short	-8755
	.short	-21206
	.short	-17141
	.short	-29336
	.short	-25271
	.short	32407
	.short	28342
	.short	24277
	.short	20212
	.short	15891
	.short	11826
	.short	7761
	.short	3696
	.short	-97
	.short	-4162
	.short	-8227
	.short	-12292
	.short	-16613
	.short	-20678
	.short	-24743
	.short	-28808
	.short	-28280
	.short	-32343
	.short	-20022
	.short	-24085
	.short	-12020
	.short	-16083
	.short	-3762
	.short	-7825
	.short	4224
	.short	161
	.short	12482
	.short	8419
	.short	20484
	.short	16421
	.short	28742
	.short	24679
	.short	-31815
	.short	-27752
	.short	-23557
	.short	-19494
	.short	-15555
	.short	-11492
	.short	-7297
	.short	-3234
	.short	689
	.short	4752
	.short	8947
	.short	13010
	.short	16949
	.short	21012
	.short	25207
	.short	29270
	.short	-18966
	.short	-23093
	.short	-27224
	.short	-31351
	.short	-2706
	.short	-6833
	.short	-10964
	.short	-15091
	.short	13538
	.short	9411
	.short	5280
	.short	1153
	.short	29798
	.short	25671
	.short	21540
	.short	17413
	.short	-22565
	.short	-18438
	.short	-30823
	.short	-26696
	.short	-6305
	.short	-2178
	.short	-14563
	.short	-10436
	.short	9939
	.short	14066
	.short	1681
	.short	5808
	.short	26199
	.short	30326
	.short	17941
	.short	22068
	.short	-9908
	.short	-13971
	.short	-1778
	.short	-5841
	.short	-26168
	.short	-30231
	.short	-18038
	.short	-22101
	.short	22596
	.short	18533
	.short	30726
	.short	26663
	.short	6336
	.short	2273
	.short	14466
	.short	10403
	.short	-13443
	.short	-9380
	.short	-5313
	.short	-1250
	.short	-29703
	.short	-25640
	.short	-21573
	.short	-17510
	.short	19061
	.short	23124
	.short	27191
	.short	31254
	.short	2801
	.short	6864
	.short	10931
	.short	14994
	.short	-722
	.short	-4849
	.short	-8852
	.short	-12979
	.short	-16982
	.short	-21109
	.short	-25112
	.short	-29239
	.short	31782
	.short	27655
	.short	23652
	.short	19525
	.short	15522
	.short	11395
	.short	7392
	.short	3265
	.short	-4321
	.short	-194
	.short	-12451
	.short	-8324
	.short	-20581
	.short	-16454
	.short	-28711
	.short	-24584
	.short	28183
	.short	32310
	.short	20053
	.short	24180
	.short	11923
	.short	16050
	.short	3793
	.short	7920
	.data
	.type	ledTargetValue, %object
	.size	ledTargetValue, 1
ledTargetValue:
	.byte	20
	.type	ledDirection, %object
	.size	ledDirection, 1
ledDirection:
	.byte	1
	.type	g_interrupt_enabled, %object
	.size	g_interrupt_enabled, 1
g_interrupt_enabled:
	.byte	1
	.bss
	.align	2
	.set	.LANCHOR0,. + 0
	.set	.LANCHOR2,. + 128
	.type	error_timeout, %object
	.size	error_timeout, 1
error_timeout:
	.space	1
	.space	1
	.type	size_of_data, %object
	.size	size_of_data, 2
size_of_data:
	.space	2
	.type	mode_of_transfer, %object
	.size	mode_of_transfer, 1
mode_of_transfer:
	.space	1
	.space	1
	.type	txLEDPulse, %object
	.size	txLEDPulse, 2
txLEDPulse:
	.space	2
	.type	b_terminal_mode, %object
	.size	b_terminal_mode, 1
b_terminal_mode:
	.space	1
	.space	3
	.type	ptr_monitor_if, %object
	.size	ptr_monitor_if, 4
ptr_monitor_if:
	.space	4
	.type	rxLEDPulse, %object
	.size	rxLEDPulse, 2
rxLEDPulse:
	.space	2
	.type	jump_cnt, %object
	.size	jump_cnt, 2
jump_cnt:
	.space	2
	.type	start_fpga_config, %object
	.size	start_fpga_config, 1
start_fpga_config:
	.space	1
	.type	jump_on_timeout, %object
	.size	jump_on_timeout, 1
jump_on_timeout:
	.space	1
	.type	b_sharp_received, %object
	.size	b_sharp_received, 1
b_sharp_received:
	.space	1
	.type	idx_rx_read, %object
	.size	idx_rx_read, 1
idx_rx_read:
	.space	1
	.type	idx_rx_write, %object
	.size	idx_rx_write, 1
idx_rx_write:
	.space	1
	.type	idx_tx_read, %object
	.size	idx_tx_read, 1
idx_tx_read:
	.space	1
	.type	idx_tx_write, %object
	.size	idx_tx_write, 1
idx_tx_write:
	.space	1
	.type	main_b_cdc_enable, %object
	.size	main_b_cdc_enable, 1
main_b_cdc_enable:
	.space	1
	.type	b_sam_ba_interface_usart, %object
	.size	b_sam_ba_interface_usart, 1
b_sam_ba_interface_usart:
	.space	1
	.space	3
	.type	PAGE_SIZE, %object
	.size	PAGE_SIZE, 4
PAGE_SIZE:
	.space	4
	.type	MAX_FLASH, %object
	.size	MAX_FLASH, 4
MAX_FLASH:
	.space	4
	.type	ptr_data, %object
	.size	ptr_data, 4
ptr_data:
	.space	4
	.type	command, %object
	.size	command, 1
command:
	.space	1
	.type	data, %object
	.size	data, 64
data:
	.space	64
	.space	3
	.type	length, %object
	.size	length, 4
length:
	.space	4
	.type	ptr, %object
	.size	ptr, 4
ptr:
	.space	4
	.type	i, %object
	.size	i, 4
i:
	.space	4
	.type	current_number, %object
	.size	current_number, 4
current_number:
	.space	4
	.type	u32tmp, %object
	.size	u32tmp, 4
u32tmp:
	.space	4
	.type	j, %object
	.size	j, 1
j:
	.space	1
	.space	3
	.type	sp, %object
	.size	sp, 4
sp:
	.space	4
	.type	src_buff_addr.11917, %object
	.size	src_buff_addr.11917, 4
src_buff_addr.11917:
	.space	4
	.type	config_done, %object
	.size	config_done, 1
config_done:
	.space	1
	.space	3
	.type	flashdata, %object
	.size	flashdata, 4
flashdata:
	.space	4
	.type	ledKeepValue, %object
	.size	ledKeepValue, 1
ledKeepValue:
	.space	1
	.type	bmRequestType.10443, %object
	.size	bmRequestType.10443, 1
bmRequestType.10443:
	.space	1
	.type	bRequest.10444, %object
	.size	bRequest.10444, 1
bRequest.10444:
	.space	1
	.space	1
	.type	wValue.10446, %object
	.size	wValue.10446, 2
wValue.10446:
	.space	2
	.type	wIndex.10447, %object
	.size	wIndex.10447, 2
wIndex.10447:
	.space	2
	.type	wLength.10448, %object
	.size	wLength.10448, 2
wLength.10448:
	.space	2
	.type	wStatus.10449, %object
	.size	wStatus.10449, 2
wStatus.10449:
	.space	2
	.type	dir.10445, %object
	.size	dir.10445, 1
dir.10445:
	.space	1
	.type	buffer_rx_usart, %object
	.size	buffer_rx_usart, 128
buffer_rx_usart:
	.space	128
	.type	buffer_tx_usart, %object
	.size	buffer_tx_usart, 128
buffer_tx_usart:
	.space	128
	.section	.isr_vector,"a",%progbits
	.align	2
	.type	exception_table, %object
	.size	exception_table, 64
exception_table:
	.word	__StackTop
	.word	Reset_Handler
	.word	NMI_Handler
	.word	HardFault_Handler
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	SVC_Handler
	.word	0
	.word	0
	.word	PendSV_Handler
	.word	SysTick_Handler
	.section	.rodata.str1.1,"aMS",%progbits,1
.LC15:
	.ascii	"\012\015\000"
.LC18:
	.ascii	"v\000"
.LC20:
	.ascii	" \000"
.LC22:
	.ascii	"Nov 10 2020\000"
.LC24:
	.ascii	"11:49:07\000"
.LC26:
	.ascii	"X\012\015\000"
.LC28:
	.ascii	"Y\012\015\000"
.LC31:
	.ascii	"Z\000"
.LC33:
	.ascii	"#\012\015\000"
.LC35:
	.ascii	">\000"
	.ident	"GCC: (GNU Tools for Arm Embedded Processors 7-2017-q4-major) 7.2.1 20170904 (release) [ARM/embedded-7-branch revision 255204]"
