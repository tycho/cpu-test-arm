#include "asmcommon.h"
.syntax unified

ENTRY(testnull)
	push {r0-r8}
	ldr r4, .LOOPS
.Lnull:
	.rept 32
	.endr
	subs r4, #1
	bne .Lnull
	pop {r0-r8}
	DO_RET(lr)
END(testnull)

ENTRY(test1i)
	push {r0-r8}
	ldr r4, .LOOPS
.L1i:
	.rept 16
	add r0, r1
	add r1, r0
	.endr
	subs r4, #1
	bne .L1i
	pop {r0-r8}
	DO_RET(lr)
END(test1i)

ENTRY(test1if)
	push {r0-r8}
	ldr r4, .LOOPS
.L1if:
	.rept 16
	adc r0, r1
	adc r1, r0
	.endr
	subs r4, #1
	bne .L1if
	pop {r0-r8}
	DO_RET(lr)
END(test1if)

ENTRY(test1ix)
	push {r0-r8}
	ldr r4, .LOOPS
.L1ix:
	.rept 16
	eor r0, r1
	eor r1, r0
	.endr
	subs r4, #1
	bne .L1ix
	pop {r0-r8}
	DO_RET(lr)
END(test1ix)

ENTRY(test1m)
	push {r0-r8}
	ldr r4, .LOOPS
.L1m:
	.rept 16
	ldr   r1, [sp]
	ldr   r2, [sp]
	.endr
	subs r4, #1
	bne .L1m
	pop {r0-r8}
	DO_RET(lr)
END(test1m)

ENTRY(test1m2)
	push {r0-r8}
	ldr r4, .LOOPS
	ldr r2, .L1m2d
	ldr r3, .L1m2d+4
	str r3, [r2, #0]
	str r2, [r3, #0]
.L1m2:
	.rept 32
	ldr   r2, [r2]
	.endr
	subs r4, #1
	bne .L1m2
	pop {r0-r8}
	DO_RET(lr)
.L1m2d:
	.word p1
	.word p2
END(test1m2)

ENTRY(test1pp)
	push {r0-r8}
	ldr r4, .LOOPS
.L1pp:
	ands r0, r4, #5
	.rept 8
#ifdef THUMB
	ittee eq
	addeq r1, r4
	addeq r2, r4
	addne r3, r4
	addne r5, r4
#else
	addeq r1, r4
	addeq r2, r4
	addne r3, r4
	addne r5, r4
#endif
	.endr
	subs r4, #1
	bne .L1pp
	pop {r0-r8}
	DO_RET(lr)
END(test1pp)

ENTRY(test1pb)
	push {r0-r8}
	ldr r4, .LOOPS
.L1pb:
	ands r0, r4, #5
	.irp lbln 1,2,3,4,5,6,7,8
	bne .L1pb\lbln
	add r1, r4
	add r2, r4
.L1pb\lbln:
	add r3, r4
	add r5, r4
	.endr
	subs r4, #1
	bne .L1pb
	pop {r0-r8}
	DO_RET(lr)
END(test1pb)

ENTRY(test2i)
	push {r0-r8}
	ldr r4, .LOOPS
.L2i:
	.rept 16
	add r0, r2
	add r1, r3
	.endr
	subs r4, #1
	bne .L2i
	pop {r0-r8}
	DO_RET(lr)
END(test2i)

ENTRY(test2if)
	push {r0-r8}
	ldr r4, .LOOPS
.L2if:
	.rept 16
	adc r0, r2
	add r1, #1
	.endr
	subs r4, #1
	bne .L2if
	pop {r0-r8}
	DO_RET(lr)
END(test2if)

ENTRY(test2ix)
	push {r0-r8}
	ldr r4, .LOOPS
.L2ix:
	.rept 16
	eor r0, r1
	add r0, #1
	.endr
	subs r4, #1
	bne .L2ix
	pop {r0-r8}
	DO_RET(lr)
END(test2ix)

ENTRY(test2m)
	push {r0-r8}
	ldr r4, .LOOPS
.L2m:
	.rept 16
	ldr   r1, [sp]
	ldr   r2, [sp, #128]
	.endr
	subs r4, #1
	bne .L2m
	pop {r0-r8}
	DO_RET(lr)
END(test2m)

ENTRY(test3i)
	push {r0-r8}
	ldr r4, .LOOPS
.L3i:
	.rept 10
	add r0, r3
	add r1, r4
	add r2, r5
	.endr
	add r0, r3
	add r1, r4
	subs r4, #1
	bne .L3i
	pop {r0-r8}
	DO_RET(lr)
END(test3i)

ENTRY(test3m)
	push {r0-r8}
	ldr r4, .LOOPS
.L3m:
	.rept 10
	ldr   r1, [sp]
	ldr   r2, [sp, #64]
	ldr   r3, [sp, #128]
	.endr
	ldr   r1, [sp]
	ldr   r2, [sp, #64]
	subs r4, #1
	bne .L3m
	pop {r0-r8}
	DO_RET(lr)
END(test3m)

ENTRY(test4i)
	push {r0-r8}
	ldr r4, .LOOPS
.L4i:
	.rept 8
	add r0, r5
	add r1, r6
	add r2, r7
	add r3, r8
	.endr
	subs r4, #1
	bne .L4i
	pop {r0-r8}
	DO_RET(lr)
END(test4i)

ENTRY(test5z)
	push {r0-r8}
	sub sp, #80
	ldr r4, .LOOPS
.L5z:
	mov r6, #0
	mov r7, #0
	str  r6, [sp]
	str  r6, [sp, #4]
	str  r6, [sp, #8]
	str  r6, [sp, #12]
	strh r6, [sp, #16]
	strh r6, [sp, #18]
	strh r6, [sp, #20]
	strh r6, [sp, #22]
	strh r6, [sp, #24]
	strh r6, [sp, #26]
	strb r6, [sp, #28]
	strb r6, [sp, #29]
	strb r6, [sp, #30]
	strb r6, [sp, #31]
	str  r6, [sp, #32]
	str  r6, [sp, #36]
	str  r6, [sp, #40]
	str  r6, [sp, #44]
	strh r6, [sp, #48]
	strh r6, [sp, #50]
	strh r6, [sp, #52]
	strh r6, [sp, #54]
	strh r6, [sp, #56]
	strh r6, [sp, #58]
	strb r6, [sp, #60]
	strb r6, [sp, #61]
	strb r6, [sp, #62]
	strb r6, [sp, #63]
	str  r6, [sp, #64]
	str  r6, [sp, #68]
	str  r6, [sp, #72]
	str  r6, [sp, #76]
	subs r4, #1
	bne .L5z
	add sp, 80
	pop {r0-r8}
	DO_RET(lr)
END(test5z)

ENTRY(test5m1)
	push {r0-r8}
	sub sp, #80
	ldr r4, .LOOPS
.L5m1:
	mvn r6, #0
	mvn r7, #0
	str  r6, [sp]
	str  r6, [sp, #4]
	str  r6, [sp, #8]
	str  r6, [sp, #12]
	strh r6, [sp, #16]
	strh r6, [sp, #18]
	strh r6, [sp, #20]
	strh r6, [sp, #22]
	strh r6, [sp, #24]
	strh r6, [sp, #26]
	strb r6, [sp, #28]
	strb r6, [sp, #29]
	strb r6, [sp, #30]
	strb r6, [sp, #31]
	str  r6, [sp, #32]
	str  r6, [sp, #36]
	str  r6, [sp, #40]
	str  r6, [sp, #44]
	strh r6, [sp, #48]
	strh r6, [sp, #50]
	strh r6, [sp, #52]
	strh r6, [sp, #54]
	strh r6, [sp, #56]
	strh r6, [sp, #58]
	strb r6, [sp, #60]
	strb r6, [sp, #61]
	strb r6, [sp, #62]
	strb r6, [sp, #63]
	str  r6, [sp, #64]
	str  r6, [sp, #68]
	str  r6, [sp, #72]
	str  r6, [sp, #76]
	subs r4, #1
	bne .L5m1
	add sp, 80
	pop {r0-r8}
	DO_RET(lr)
END(test5m1)

ENTRY(test5l1)
	push {r0-r8}
	ldr r4, .LOOPS
.L5l1:
	mov  r0, #0
	mov  r0, #1
	mov  r0, #2
	mov  r0, #3
	mov  r0, #4
	mov  r0, #5
	mov  r0, #6
	mov  r0, #7
	mov  r0, #8
	mov  r0, #9
	mov  r0, #10
	mov  r0, #11
	mov  r0, #12
	mov  r0, #13
	mov  r0, #14
	mov  r0, #15
	mov  r0, #16
	mov  r0, #17
	mov  r0, #18
	mov  r0, #19
	mov  r0, #20
	mov  r0, #21
	mov  r0, #22
	mov  r0, #23
	mov  r0, #24
	mov  r0, #25
	mov  r0, #26
	mov  r0, #27
	mov  r0, #28
	mov  r0, #29
	mov  r0, #30
	mov  r0, #31
	subs r4, #1
	bne .L5l1
	pop {r0-r8}
	DO_RET(lr)
END(test5l1)

ENTRY(test6zi)
	push {r0-r8}
	sub sp, #32
	ldr r4, .LOOPS
.L6zi:
	.rept 4
	ldr r0, [sp]
	and r0, #0
	str r0, [sp]
	ldr r1, [sp, #4]
	and r1, #0
	str r1, [sp, #4]
	ldr r2, [sp, #8]
	and r2, #0
	str r2, [sp, #8]
	ldr r3, [sp, #12]
	and r3, #0
	str r3, [sp, #12]
	ldr r5, [sp, #16]
	and r5, #0
	str r5, [sp, #16]
	ldr r6, [sp, #20]
	and r6, #0
	str r6, [sp, #20]
	ldr r7, [sp, #24]
	and r7, #0
	str r7, [sp, #24]
	ldr r8, [sp, #28]
	and r8, #0
	str r8, [sp, #28]
	.endr
	subs r4, #1
	bne .L6zi
	add sp, 32
	pop {r0-r8}
	DO_RET(lr)
END(test6zi)

ENTRY(test6zr)
	push {r0-r8}
	sub sp, #32
	ldr r4, .LOOPS
.L6zr:
	.rept 4
	mov r9, #0
	ldr r0, [sp]
	and r0, r9
	str r0, [sp]
	ldr r1, [sp, #4]
	and r1, r9
	str r1, [sp, #4]
	ldr r2, [sp, #8]
	and r2, r9
	str r2, [sp, #8]
	ldr r3, [sp, #12]
	and r3, r9
	str r3, [sp, #12]
	ldr r5, [sp, #16]
	and r5, r9
	str r5, [sp, #16]
	ldr r6, [sp, #20]
	and r6, r9
	str r6, [sp, #20]
	ldr r7, [sp, #24]
	and r7, r9
	str r7, [sp, #24]
	ldr r8, [sp, #28]
	and r8, r9
	str r8, [sp, #28]
	subs r4, #1
	.endr
	bne .L6zr
	add sp, 32
	pop {r0-r8}
	DO_RET(lr)
END(test6zr)

	.comm   p2,4,4
	.comm   p1,4,4

.LOOPS:
	.word 6000000
