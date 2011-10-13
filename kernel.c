/*
 * Miscellaneous kernel tests
 */

#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

#include "kernel.h"
#include "util.h"

uint32_t test3pflt(void)
{
	uint32_t pgsz, alloc;
	uint8_t *p;
	uint32_t i, s, e;

	pgsz = sysconf(_SC_PAGESIZE);
	alloc = pgsz * 32768;
	p = (uint8_t *)mmap(NULL, alloc, PROT_WRITE | PROT_READ, MAP_PRIVATE | MAP_ANON, -1, 0);
	assert(p != MAP_FAILED);

	e = tm_ticks();
	do {
		s = tm_ticks();
	} while ((s - e) < 1);
	for (i = 0; i < alloc; i += pgsz) {
		p[i] = 0x1F;
	}
	e = tm_ticks();
	i = e - s;
	munmap(p, alloc);
	return i;
}
