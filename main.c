#include "prefix.h"
#include "version.h"

#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include <unistd.h>

#define LOOPS 6000000
#define INSTR 32

uint64_t vRefSpeed;
uint32_t vfClocksOnly;
uint32_t volatile vt1;

extern void testnull(void);
extern void test1i(void);
extern void test1if(void);
extern void test1ix(void);
extern void test1m(void);
extern void test1m2(void);
extern void test1pp(void);
extern void test1pb(void);
extern void test2i(void);
extern void test2if(void);
extern void test2ix(void);
extern void test2m(void);
extern void test3i(void);
extern void test3m(void);
extern void test4i(void);

/* ticks in microseconds */
static uint32_t tm_ticks(void)
{
    struct timespec t;
#ifdef _POSIX_MONOTONIC_CLOCK
    clock_gettime(CLOCK_MONOTONIC, &t);
#else
	clock_gettime(CLOCK_REALTIME, &t);
#endif
    return 1000000LL * (uint64_t)t.tv_sec + (uint64_t)(t.tv_nsec / 1000);
}

/* in microseconds */
static uint32_t tm_resolution(void)
{
	uint64_t a, b, c = 1E6;
	int i;
	for (i = 0; i < 10; i++) {
		a = tm_ticks();
		while (a == (b = tm_ticks()));
		while (b == (a = tm_ticks()));
		if (a - b < c)
			c = a - b;
	}
	return c;
}

/* in microseconds */
static uint32_t get_overhead(void)
{
	uint32_t t1, t2, res;

	res = tm_resolution();

	testnull();
	vt1 = tm_ticks();
	do
	{
		t1 = tm_ticks();
	} while ((t1 - vt1) < res);
	vt1 = t1;
	testnull();
	testnull();
	testnull();
	t2 = tm_ticks();
	t1 = vt1;

	return (t2 - t1) / 3;
}

static void run_test(void (*pfn)(void), char *title, uint32_t loops, uint32_t instr)
{
	static uint32_t overhead = 0;
	uint32_t t1, t2, td, res;
	uint64_t ipms;
	uint32_t tinst = instr * loops;
	float ipc, clk;

	usleep(1000);
#if 1
	if (!overhead)
		overhead = get_overhead();
#endif
	res = tm_resolution();

	vt1 = tm_ticks();
	do
	{
		t1 = tm_ticks();
	} while ((t1 - vt1) < res);
	vt1 = t1;
	(*pfn)();
	t2 = tm_ticks();
	t1 = vt1;

	if (t2 == t1)
		t2++;

	td = (t2 - t1 - overhead) / 1000L;
	if (td < 1)
		td = 1;

	printf("%-19s: %7d ms, ", title, td);

	if (tinst / td / 1000L == 0)
	{
		printf("%9lu ns/test, ", (td * 1000000L) / tinst);
		printf(" 0.%03lu MIPS, ", tinst * 1000L / td);
	}
	else
	{
		printf("%9llu ps/test, ", (td * 1000000000LL) / tinst);
		printf("%6lu MIPS, ", tinst / td / 1000L);
	}

	ipms = tinst / td;

	if (vRefSpeed == 0)
		vRefSpeed = ipms;

	ipc = (float)ipms / (float)vRefSpeed;
	clk = (float)vRefSpeed / (float)ipms;

	/* If we're pushing enough instructions through per
	   clock cycle, print IPC instead of clocks. */
	if (!vfClocksOnly && ipc >= 1.06f)
		printf("%1.1f IPC", ipc);
	else
		printf("%1.1f clk", clk);

	printf("\n");
	fflush(stdout);
}

static void usage(const char *argv0)
{
    printf("usage: %s\n\n", argv0);
    printf("  %-18s %s\n", "-m, --mhz", "Manually define the clock speed of the test target");
    printf("  %-18s %s\n", "-h, --help", "Print this list of options");
    printf("  %-18s %s\n", "-v, --version", "Print the program license and version information");
    printf("\n");
    exit(0);
}

static void version(void)
{
    printf("CPU_TEST for ARM version %s\n\n", app_version_long());
    license();
    exit(0);
}

int main(int argc, char **argv)
{
	vRefSpeed = 0;

	while (TRUE) {
		static struct option long_options[] = {
			{"mhz", required_argument, 0, 'm'},
			{"version", no_argument, 0, 'v'},
			{"help", no_argument, 0, 'h'},
			{0, 0, 0, 0}
		};
		int c, option_index = 0;

		c = getopt_long(argc, argv, "hvm:", long_options, &option_index);
		if (c == -1)
			break;
		switch (c) {
		case 0:
			break;
		case 'm':
			assert(optarg);
			if (sscanf(optarg, "%llu", &vRefSpeed) != 1) {
				printf("Option --mhz= requires an integer parameter.\n");
				exit(1);
			}
			vRefSpeed *= 1000;
			break;
		case 'v':
			version();
		case 'h':
		case '?':
		default:
			usage(argv[0]);
		}
	}

	if (vRefSpeed == 0)
		run_test(test1i,  "calibrating     ", LOOPS, INSTR);

	printf("\nSimple tests of integer and memory operations.\n"
	       "Ideally, MIPS should equal the clock speed of your CPU.\n\n");

	run_test(test1i,  "test 1 int add  ", LOOPS, INSTR);
	run_test(test1if, "test 1 int adc  ", LOOPS, INSTR);
	run_test(test1ix, "test 1 int xor  ", LOOPS, INSTR);
	run_test(test1m,  "test 1 mem load ", LOOPS, INSTR);
	run_test(test1m2, "test 1 mem indir", LOOPS, INSTR);
	run_test(test1pp, "test 1 cond pred", LOOPS, INSTR);
	run_test(test1pb, "test 1 cond bran", LOOPS, INSTR);

	printf("\nTests executing pairs of mutually exclusive instructions.\n"
		   "You should ideally get double the MIPS.\n\n");

	run_test(test2i,  "test 2 int add  ", LOOPS, INSTR);
	run_test(test2if, "test 2 int adc++", LOOPS, INSTR);
	run_test(test2ix, "test 2 int xor++", LOOPS, INSTR);
	run_test(test2m,  "test 2 mem load ", LOOPS, INSTR);

	printf("\nTriples of mutually exclusive instructions should \n"
		   "ideally give triple the MIPS.\n\n");

	run_test(test3i,  "test 3 int add  ", LOOPS, INSTR);
	run_test(test3m,  "test 3 mem load ", LOOPS, INSTR);
	run_test(test4i,  "test 4 int add  ", LOOPS, INSTR);
	return 0;
}
