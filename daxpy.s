; daxpy( N, alpha, x, strideX, y, strideY )
; w0 		- int N, which is the number of elements, not the length
;			of an array
; s0	 	- scalar alpha, to be multiplied against every element in *x
; x1 		- pointer to array x
; w2		- stride to pass through arrayX
; w3		- stride to pass through arrayY
daxpy: 
	; Create a stack of 32 bytes just cause
	stp	x29, x30, [sp,-32]!
	str	wzr, [sp, 16]		; i = 0

; The stride of the arrays is based on strideX * the size of a double, which
; is 8 bytes. Promote strideX and strideY to 64-bits so we can add them 
; directly into the arrays
	sxtw	x2, w2		; Promote strideX	
	sxtw	x3, w3		; Promote strideY
	mov	x9, #64		; Size of a double
	mul	x10, x2, x9 	; Stride on y
	mul	x11, x3, x9 	; Stride on x

looptop:
	; One-time stuff for the loop
	ldr	w12, [sp, 16]	; i
	b looptest
loopbody:
		
looptest:
	cmp 	w12, w0
	blt	loopbody		

	ldp 	x29, x30, [sp], 32
	ret
