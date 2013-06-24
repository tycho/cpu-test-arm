#include "asmcommon.h"
.syntax unified

TEST_ENTRY(testnull)
.Lnull:
	.rept 32
	.endr
	subs r4, #1
	bne .Lnull
TEST_END(testnull)

TEST_ENTRY(test1i)
.L1i:
	.rept 16
	add r0, r1
	add r1, r0
	.endr
	subs r4, #1
	bne .L1i
TEST_END(test1i)

TEST_ENTRY(test1if)
.L1if:
	.rept 16
	adc r0, r1
	adc r1, r0
	.endr
	subs r4, #1
	bne .L1if
TEST_END(test1if)

TEST_ENTRY(test1ix)
.L1ix:
	.rept 16
	eor r0, r1
	eor r1, r0
	.endr
	subs r4, #1
	bne .L1ix
TEST_END(test1ix)

TEST_ENTRY(test1m)
.L1m:
	.rept 16
	ldr   r1, [sp]
	ldr   r2, [sp]
	.endr
	subs r4, #1
	bne .L1m
TEST_END(test1m)

.L1m2d:
	.word p1
	.word p2
TEST_ENTRY(test1m2)
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
TEST_END(test1m2)

TEST_ENTRY(test1pp)
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
TEST_END(test1pp)

TEST_ENTRY(test1pb)
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
TEST_END(test1pb)

TEST_ENTRY(test2i)
.L2i:
	.rept 16
	add r0, r2
	add r1, r3
	.endr
	subs r4, #1
	bne .L2i
TEST_END(test2i)

TEST_ENTRY(test2if)
.L2if:
	.rept 16
	adc r0, r2
	add r1, #1
	.endr
	subs r4, #1
	bne .L2if
TEST_END(test2if)

TEST_ENTRY(test2ix)
.L2ix:
	.rept 16
	eor r0, r1
	add r0, #1
	.endr
	subs r4, #1
	bne .L2ix
TEST_END(test2ix)

TEST_ENTRY(test2m)
.L2m:
	.rept 16
	ldr   r1, [sp]
	ldr   r2, [sp, #128]
	.endr
	subs r4, #1
	bne .L2m
TEST_END(test2m)

TEST_ENTRY(test3i)
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
TEST_END(test3i)

TEST_ENTRY(test3m)
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
TEST_END(test3m)

TEST_ENTRY(test4i)
.L4i:
	.rept 8
	add r0, r5
	add r1, r6
	add r2, r7
	add r3, r8
	.endr
	subs r4, #1
	bne .L4i
TEST_END(test4i)

TEST_ENTRY(test5z)
	sub sp, #80
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
TEST_END(test5z)

TEST_ENTRY(test5m1)
	sub sp, #80
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
TEST_END(test5m1)

TEST_ENTRY(test5l1)
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
TEST_END(test5l1)

TEST_ENTRY(test6zi)
	sub sp, #32
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
TEST_END(test6zi)

TEST_ENTRY(test6zr)
	sub sp, #32
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
TEST_END(test6zr)

TEST_ENTRY(test6m1)
	sub sp, #32
.L6m1:
	.rept 4
	mvn r9, #0
	ldr r0, [sp]
	orr r0, r9
	str r0, [sp]
	ldr r1, [sp, #4]
	orr r1, r9
	str r1, [sp, #4]
	ldr r2, [sp, #8]
	orr r2, r9
	str r2, [sp, #8]
	ldr r3, [sp, #12]
	orr r3, r9
	str r3, [sp, #12]
	ldr r5, [sp, #16]
	orr r5, r9
	str r5, [sp, #16]
	ldr r6, [sp, #20]
	orr r6, r9
	str r6, [sp, #20]
	ldr r7, [sp, #24]
	orr r7, r9
	str r7, [sp, #24]
	ldr r8, [sp, #28]
	orr r8, r9
	str r8, [sp, #28]
	.endr
	subs r4, #1
	bne .L6m1
	add sp, 32
TEST_END(test6m1)

TEST_ENTRY(test6l1)
.L6l1:
	.rept 4
	push {r0}
	pop {r8}
	push {r1}
	pop {r7}
	push {r2}
	pop {r6}
	push {r3}
	pop {r5}
	push {r5}
	pop {r3}
	push {r6}
	pop {r2}
	push {r7}
	pop {r1}
	push {r8}
	pop {r0}
	.endr
	subs r4, #1
	bne .L6l1
TEST_END(test6l1)

TEST_ENTRY(test8mul)
.L8mul:
	sub r0, r4, 1
	.rept 32
	mul r0, r0, r4
	.endr
	subs r4, #1
	bne .L8mul
TEST_END(test8mul)

TEST_ENTRY(test9fpm)
.L9fpm:
	sub r0, r4, 1
	vmov s14, r0
	vcvt.f32.s32 s0, s14
	vmov s14, r4
	vcvt.f32.s32 s1, s14
	.rept 32
	vmul.f32 s0, s0, s1
	.endr
	subs r4, #1
	bne .L9fpm
TEST_END(test9fpm)

TEST_ENTRY(test10fpq)
.L10fpq:
	sub r0, r4, 1
	vmov s14, r0
	vcvt.f32.s32 s0, s14
	.rept 32
	vsqrt.f32 s1, s0
	.endr
	subs r4, #1
	bne .L10fpq
TEST_END(test10fpq)

	.comm   p2,4,4
	.comm   p1,4,4
