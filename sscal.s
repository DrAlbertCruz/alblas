; SSCAL() created for Mac
	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 4
	.globl	_sscal                          ; -- Begin function sscal
	.p2align	2
_sscal:                                 ; @sscal
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	w0, [sp, #28]	; n
	str	s0, [sp, #24]	; a
	str	x1, [sp, #16]	; *x
	str	s1, [sp, #12]	; b
	ldr	w8, [sp, #28]

	; Unlike Linux GCC, Mac's clang seems to use a combination of 
	; subs, cset and tbnz. We can infer that subs is performing the 
	; equivalent of a - b == 0
	subs	w8, w8, #0
	; if n > 0 proceed to LBB0_2
	cset	w8, gt
	tbnz	w8, #0, LBB0_2
	; Below must be the test case for n <= 0
	; Why is it juping to LBB_01?
	b	LBB0_1
LBB0_1:
	b	LBB0_8
LBB0_2:
	; clang is refreshing *x on the stack here
	ldr	x8, [sp, #16]
	; *x != 0 then jump to LBB0_4
	subs	x8, x8, #0
	cset	w8, ne
	tbnz	w8, #0, LBB0_4
	b	LBB0_3
LBB0_3:
	b	LBB0_8
LBB0_4:
	; This appears to be a section dedicated to one-time items to run before
	; attempting to start the loop body.
	; Here is where it sets i = 0
	str	wzr, [sp, #8]
	; Here, I set x11 to point to the start of the array at *x
	ldr	x11, [sp, #16]
	; All cases will not use simd, but we preload the values here just in case
	; scratch vector registers start at 16. Due to poor documentation its not
	; obvious but ARM broadcast instructions cannot have a literal offset
	; of the pointer provided, we have to use an arithmetic instruction to
	; offset the stack pointer.
	add 	x12, sp, 24	; a
	ld1r 	{v16.2s}, [x12] 
	ld1r 	{v18.4s}, [x12] 
	add 	x12, sp, 12 ; b
	ld1r 	{v17.2s}, [x12] 
	ld1r 	{v19.4s}, [x12] 
	; TODO: It's not clear to me if 4s would cover the 2s case, most likely
	; Feel it is unnecessary to fall through into LBB0_5
	
	; Prep for SIMD branches. If 'n' is not divisible by 2, run the conventional
	; branch exactly once. clang seems to like r8 a lot
checkOdd:
	and	w8, w0, #1	; Mask LSB 
	cmp 	w8, wzr		; If LSB ...
	bne 	LBB0_6		; is not equal to zero, it is odd
checkDiv2:
	b	simd2
LBB0_5:                                 ; =>This Inner Loop Header: Depth=1
	; This is an inner loop that determines if we should loop again
	; Refresh the value of i
	ldr	w8, [sp, #8]
	; Refreshes the value of n 
	ldr	w9, [sp, #28]
	; i - n == 0 ... if i > n jump to LBB0_8
	subs	w8, w8, w9
	cset	w8, ge
	tbnz	w8, #0, LBB0_8
	b	simd2
LBB0_6:                                 ;   in Loop: Header=BB0_5 Depth=1
	; What clang originally created. We repurpose it here to run exactly once
	; our SIMD implementation. 
	; It refreshes the value of a here, not necessary
	; ldr	s0, [sp, #24]
	
	; It refreshes the pointer to x here
	; Loads value of i again
	ldrsw	x9, [sp, #8]
	
	; Suboptimal *(x + 4 * i), into s1
	; ldr	s1, [x8, x9, lsl #2]
	; Instead, just deference. Later will will physically move the pointer.
	ldr 	s3, [x11]
	
	; Refreshes B here, but we never clobbered s1
	; ldr	s2, [sp, #12]
	
	; The actual SSCAL math, adjust some registers
	fmadd	s3, s3, s0, s1

	; Here it refreshes *x again
	; ldr	x8, [sp, #16]
	; ldrsw	x9, [sp, #8]
	; str	s0, [x8, x9, lsl #2]
	; Instead: Store and use a post-index
	str	s3, [x11], 4
	
	; Why does it branch into a fall through?
	; b	LBB0_7
LBB0_7:                                 ;   in Loop: Header=BB0_5 Depth=1
	ldr	w8, [sp, #8]
	add	w8, w8, #1
	str	w8, [sp, #8]
	b	checkDiv2
simd2:
	; SIMD 2 implementation of sscal()
	; Loads value of i again
	ldrsw	x9, [sp, #8]
	; Deref x[i]
	ld1 	{v20.2s}, [x11]
	; The actual SSCAL math, adjust some registers
	; fmadd does not seem to work for SIMD
	; TODO: investigate why
	; fmadd	v20.2s, v16.2s, v16.2s, v17.2s
	fmul 	v20.2s, v16.2s, v20.2s
	fadd	v20.2s, v20.2s, v17.2s
	; Store and use a post-index
	st1	{v20.2s}, [x11], 8
	ldr	w8, [sp, #8]
	add	w8, w8, #2
	str	w8, [sp, #8]
	b	LBB0_5
LBB0_8:
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
