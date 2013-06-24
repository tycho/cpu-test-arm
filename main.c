#include "prefix.h"
#include "cpu-arm.h"
#include "kernel.h"
#include "util.h"
#include "version.h"

#include <getopt.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include <unistd.h>

const uint32_t LOOPS = 6000000;
const uint32_t INSTR = 32;

uint32_t vRefSpeed;
int32_t vfSimpleTests;
int32_t vfKernelTests;
int32_t vfClocksOnly;
uint32_t volatile vt1;

/* in microseconds */
static uint32_t get_overhead(void)
{
	uint32_t i, res, t1, t2, d, min = (uint32_t)-1;

	res = tm_resolution();

	for (i = 0; i < 100; i++) {
		vt1 = tm_ticks();
		do
		{
			t1 = tm_ticks();
		} while ((t1 - vt1) < res);
		vt1 = t1;
		testnull();
		t2 = tm_ticks();
		d = t2 - t1;
		if (min > d)
			min = d;
	}

	return min;
}

static void run_test(void (*btest)(void), uint32_t (*ttest)(void), char *title, uint32_t loops, uint32_t instr)
{
	static uint32_t overhead = 0;
	uint32_t i, t1, t2, td, min = (uint32_t)-1, res;
	float ips;
	uint32_t tinst = instr * loops;
	float ipc, clk;

	pthread_yield();
#if 0
	if (!overhead) {
		printf("calculating test overhead... ");
		fflush(stdout);
		overhead = get_overhead();
		printf("%u usec\n", overhead);
	}
#endif
	for (i = 0; i < 3; i++) {
		if (btest) {
			res = tm_resolution();

			vt1 = tm_ticks();
			do
			{
				t1 = tm_ticks();
			} while ((t1 - vt1) < res);
			vt1 = t1;
			(*btest)();
			t2 = tm_ticks();
			t1 = vt1;

			if (t2 == t1)
				t2++;

			td = (t2 - t1 - overhead);
		} else if (ttest) {
			td = (*ttest)();
		} else {
			abort();
		}
		if (min > td)
			min = td;
	}
	td = min;

	if (td < 1)
		td = 1;

	printf("%-19s: %9.2f ms, ", title, (float)td / 1000.0f);

	ips = ((float)tinst / ((float)td / 1000.0f)) / 1000.0f;

	if (tinst / td == 0)
	{
		printf("%9lu ns/test, ", (td * 1000L) / tinst);
		printf("%6.3f MIPS, ", ips);
	}
	else
	{
		printf("%9llu ps/test, ", (td * 1000000LL) / tinst);
		printf("%6.0f MIPS, ", ips);
	}


	if (vRefSpeed == 0)
		vRefSpeed = (uint32_t)ips;

	ipc = (float)ips / (float)vRefSpeed;
	clk = (float)vRefSpeed / (float)ips;

	/* If we're pushing enough instructions through per
	   clock cycle, print IPC instead of clocks. */
	if (!vfClocksOnly && ipc >= 1.1f)
		printf("%8.1f IPC", ipc);
	else
		printf("%8.1f clk", clk);

	printf("\n");
	fflush(stdout);
}

static void usage(const char *argv0)
{
    printf("usage: %s\n\n", argv0);
    printf("  %-18s %s\n", "-m, --mhz", "Manually define the clock speed of the test target");
    printf("  %-18s %s\n", "--clk", "Disable IPC measurement, only measure in clock cycles");
    printf("  %-18s %s\n", "--none", "Disable all tests. Append other arguments to enable test groups individually.");
    printf("  %-18s %s\n", "--simple", "Enable the simple instruction tests");
    printf("  %-18s %s\n", "--kernel", "Enable the kernel-level tests");
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

	vfClocksOnly = 0;
	vfSimpleTests = 1;
	vfKernelTests = 0;

	while (TRUE) {
		static struct option long_options[] = {
			{"mhz", required_argument, 0, 'm'},
			{"clk", no_argument, &vfClocksOnly, 1},
			{"none", no_argument, 0, 2},
			{"simple", no_argument, &vfSimpleTests, 1},
			{"kernel", no_argument, &vfKernelTests, 1},
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
		case 2:
			vfSimpleTests = 0;
			vfKernelTests = 0;
			break;
		case 'm':
			assert(optarg);
			if (sscanf(optarg, "%u", &vRefSpeed) != 1) {
				printf("Option --mhz= requires an integer parameter.\n");
				exit(1);
			}
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
		run_test(test1i, NULL,  "calibrating     ", LOOPS, INSTR);

	if (vfSimpleTests) {
		printf("\nSimple tests of integer and memory operations.\n"
			   "Ideally, MIPS should equal the clock speed of your CPU.\n\n");

		run_test(test1i,    NULL, "test 1 int add  ", LOOPS, INSTR);
		run_test(test1if,   NULL, "test 1 int adc  ", LOOPS, INSTR);
		run_test(test1ix,   NULL, "test 1 int xor  ", LOOPS, INSTR);
		run_test(test1m,    NULL, "test 1 mem load ", LOOPS, INSTR);
		run_test(test1m2,   NULL, "test 1 mem indir", LOOPS, INSTR);
		run_test(test1pp,   NULL, "test 1 cond pred", LOOPS, INSTR / 2);
		run_test(test1pb,   NULL, "test 1 cond bran", LOOPS, INSTR / 2);

		printf("\nTests executing pairs of mutually exclusive instructions.\n"
			   "You should ideally get double the MIPS.\n\n");

		run_test(test2i,    NULL, "test 2 int add  ", LOOPS, INSTR);
		run_test(test2if,   NULL, "test 2 int adc++", LOOPS, INSTR);
		run_test(test2ix,   NULL, "test 2 int xor++", LOOPS, INSTR);
		run_test(test2m,    NULL, "test 2 mem load ", LOOPS, INSTR);

		printf("\nTriples of mutually exclusive instructions should \n"
			   "ideally give triple the MIPS.\n\n");

		run_test(test3i,    NULL, "test 3 int add  ", LOOPS, INSTR);
		run_test(test3m,    NULL, "test 3 mem load ", LOOPS, INSTR);
		run_test(test4i,    NULL, "test 4 int add  ", LOOPS, INSTR);

		printf("\nThese are tests of simple integer operations.\n\n");

		run_test(test5z,    NULL, "test 5 zero mem ", LOOPS, INSTR);
		run_test(test5m1,   NULL, "test 5 -1 to mem", LOOPS, INSTR);
		run_test(test5l1,   NULL, "test 5 load 1   ", LOOPS, INSTR);

		run_test(test6zi,   NULL, "test 6 and0 mimm", LOOPS, INSTR);
		run_test(test6zr,   NULL, "test 6 and0 mreg", LOOPS, INSTR);
		run_test(test6m1,   NULL, "test 6 or-1 mreg", LOOPS, INSTR);
		run_test(test6l1,   NULL, "test 6 pushpop 1", LOOPS, INSTR);

		/* test7 = unsigned integer divide -- unavailable on ARMv7-A */

		run_test(test8mul,   NULL, "test 8 multiply ", LOOPS, INSTR);
		run_test(test9fpm,   NULL, "test 9 FP mult  ", LOOPS, INSTR);
		run_test(test10fpq,  NULL, "test 10 FP sqrt ", LOOPS, INSTR);
		run_test(test11fls,  NULL, "test 11 FP ld/st", LOOPS, INSTR);
		run_test(test12fi1,  NULL, "test 12 FP inc 1", LOOPS, INSTR);
	}

	if (vfKernelTests) {
		printf("\nThese tests perform various kernel calls.\n\n");

		run_test(NULL, test3pflt, "test 3 os pg flt", 32768, 1);
	}
	return 0;
}
