#ifndef __included_asmcommon_h
#define __included_asmcommon_h

/* TODO: Detect this automatically. */
#ifdef __THUMBEL__
#define THUMB
#endif
#define HAVE_ELF
#define ASM_GLOBAL_DIRECTIVE .globl
#define NO_UNDERSCORES

#ifndef C_LABEL
#ifdef	NO_UNDERSCORES
#ifdef	__STDC__
#define C_LABEL(name)		name##:
#else
#define C_LABEL(name)		name/**/:
#endif
#else
#ifdef	__STDC__
#define C_LABEL(name)		_##name##:
#else
#define C_LABEL(name)		_/**/name/**/:
#endif
#endif
#endif

#ifndef C_SYMBOL_NAME
# ifdef NO_UNDERSCORES
#  define C_SYMBOL_NAME(name) name
# else
#  define C_SYMBOL_NAME(name) _##name
# endif
#endif

# ifndef END
# define END(sym)
# endif

# ifndef JUMPTARGET
# define JUMPTARGET(sym)	sym
# endif

#if (!defined (__ARM_ARCH_2__) && !defined (__ARM_ARCH_3__) \
     && !defined (__ARM_ARCH_3M__) && !defined (__ARM_ARCH_4__))
# define __USE_BX__
#endif

#ifdef HAVE_ELF

#define ALIGNARG(log2) log2
/* For ELF we need the `.type' directive to make shared libs work right.  */
#define ASM_TYPE_DIRECTIVE(name,typearg) .type name,%##typearg;
#define ASM_SIZE_DIRECTIVE(name) .size name,.-name

/* In ELF C symbols are asm symbols.  */
#undef	NO_UNDERSCORES
#define NO_UNDERSCORES

#define PLTJMP(_x)	_x##(PLT)

#else

#define ALIGNARG(log2) log2
#define ASM_TYPE_DIRECTIVE(name,type)	/* Nothing is specified.  */
#define ASM_SIZE_DIRECTIVE(name)	/* Nothing is specified.  */

#define PLTJMP(_x)	_x

#endif

/* APCS-32 doesn't preserve the condition codes across function call. */
#ifdef __APCS_32__
#define LOADREGS(cond, base, reglist...)\
	ldm##cond	base,reglist
#ifdef __USE_BX__
#define RETINSTR(cond, reg)	\
	bx##cond	reg
#define DO_RET(_reg)		\
	bx _reg
#else
#define RETINSTR(cond, reg)	\
	mov##cond	pc, reg
#define DO_RET(_reg)		\
	mov pc, _reg
#endif
#else  /* APCS-26 */
#define LOADREGS(cond, base, reglist...)\
	ldm##cond	base,reglist^
#define RETINSTR(cond, reg)	\
	mov##cond##s	pc, reg
#define DO_RET(_reg)		\
	movs pc, _reg
#endif

#ifdef THUMB
#define THUMB_FUNC .thumb_func
#else
#define THUMB_FUNC
#endif

/* Define an entry point visible from C.  */
#define	ENTRY(name)                                           \
  THUMB_FUNC;                                                 \
  ASM_GLOBAL_DIRECTIVE C_SYMBOL_NAME(name);                   \
  ASM_TYPE_DIRECTIVE (C_SYMBOL_NAME(name),function)           \
  .align ALIGNARG(4);                                         \
  C_LABEL(name)                                               \
  CALL_MCOUNT

#undef	END
#define END(name)							      \
  ASM_SIZE_DIRECTIVE(name)

/* If compiled for profiling, call `mcount' at the start of each function.  */
#ifdef	PROF
#define CALL_MCOUNT			\
	str	lr,[sp, #-4]!	;	\
	bl	PLTJMP(mcount)	;	\
	ldr	lr, [sp], #4	;
#else
#define CALL_MCOUNT		/* Do nothing.  */
#endif

#if defined(__ARM_EABI__)
/* Tag_ABI_align8_preserved: This code preserves 8-byte
   alignment in any callee.  */
	.eabi_attribute 25, 1
/* Tag_ABI_align8_needed: This code may require 8-byte alignment from
   the caller.  */
	.eabi_attribute 24, 1
#endif

#if defined(THUMB)
    .thumb
#endif

#endif
