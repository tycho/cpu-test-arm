#include "util.h"

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
