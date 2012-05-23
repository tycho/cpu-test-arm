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

	.comm   p2,4,4
	.comm   p1,4,4

.LOOPS:
	.word 6000000
