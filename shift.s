@ Free & Reserved Register
@ X {r0} : TIMER_BASE address.
@   {r1} : free.
@   {r2} : free.
@   {r3} : free.
@   {r4} : free.
@ X {r5} : target_time.
@ X {r6} : current_time. and frame_buffer address.
@   {r7} : free.
@   {r8} : free.
@   {r9} : free.
@   {r10}: free.
@   {r11}: free.
@ X {r12}: frame_buffer 'ldr or str'
	
				.include "common.h"
				.section .text
				.global shift
shift:
@frame_buffer shift
				ldr	r6, [r0, #GPFSEL1]
				cmp	r6, r5
				bxcc	r14
@ Initialize flags
				cmp		r10, #1
				bne		shiftp
				cmp		r8, #0
				bne		shiftp
				sub		r7, r7, #1
				ldr		r12, =frame_buffer
				ldrb	r11,[r12]
				lsl		r11,r11,#1
				strb	r11,[r12]	
shiftp:
				mov		r8,		#0		@OK  Flag
				str		r8,		[r3, #16]
				mov		r10,	#0		@ Miss Flag

				push	{r10}
@ update target time
				ldr	r11,	[r3, #20]
				add	r6,	r3,	r11
				ldr	r10, [r6]
				add	r5, r5, r10
				add	r9, r9, #1
				cmp	r9, #64
				moveq	r9, #0
@frame_buffer shift 
				ldr	r6, =frame_buffer
				mov	r10, #6
				frame_shift:
@this frame_shift chage from B~G to C~H.
				ldrb	r12, [r6, r10]
				add	r11, r10, #1
				strb	r12, [r6, r11]
				sub	r10, r10, #1
				cmp	r10, #0
				bne	frame_shift
END:
				pop	{r10}
				bx	r14
