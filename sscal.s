	.arch armv8-a
	.file	"sscal.c"
	.text
	.align	2
	.global	sscal
	.type	sscal, %function
sscal:
.LFB0:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	# Length N
	str	w0, [sp, 28]
	# Scalar ALPHA
	str	s0, [sp, 24]
	# float* X
	str	x1, [sp, 16]
	# Scalar INCX
	str	s1, [sp, 12]
	# Not necessary because w0 still contains N
	# ldr	w0, [sp, 28]
	cmp	w0, 0
	ble	.L7
	ldr	x0, [sp, 16]
	cmp	x0, 0
	beq	.L8

	# There is no need for an I variable, use a saved register instead.
	str	x19, [sp]
	mov 	w19, wzr
	
	# Set a temporary to *X that iterates through array
	ldr 	x9, [sp, 16]
	# Preload the value of N here instead of in .L5
	ldr	w0, [sp, 28]
	
	b	.L5
.L6:
	# If you put it in s2 you dont clobber ALPHA and INCX ...
	ldr 	s2, [x9]	
	fmul	s2, s2, s0
	fadd	s2, s2, s1
	# ... use post index to save some calculations.
	str 	s2, [x9], 4
	add	w19, w19, 1
.L5:
	cmp	w19, w0
	blt	.L6
	b	.L1
.L7:
	nop
	b	.L1
.L8:
	nop
.L1:
	ldr 	x19, [sp]
	add	sp, sp, 48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	sscal, .-sscal
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
