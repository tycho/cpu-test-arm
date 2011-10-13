#include <stdint.h>
#include <time.h>
#include <unistd.h>

#include "util.h"

/* ticks in microseconds */
uint32_t tm_ticks(void)
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
uint32_t tm_resolution(void)
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
