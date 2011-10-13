#ifndef __included_util_h
#define __included_util_h

#include <stdint.h>
#include <time.h>
#include <unistd.h>

/* ticks in microseconds */
static inline uint32_t tm_ticks(void)
{
	struct timespec t;
#ifdef _POSIX_MONOTONIC_CLOCK
	clock_gettime(CLOCK_MONOTONIC, &t);
#else
	clock_gettime(CLOCK_REALTIME, &t);
#endif
	return 1000000LL * (uint64_t)t.tv_sec + (uint64_t)(t.tv_nsec / 1000);
}

uint32_t tm_resolution(void);

#endif
