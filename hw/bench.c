// Overhead microbenchmark for the V1 index-masking wrapper (P550 / any RV64 Linux board).
// Measures the cost of the mitigation on IN-BOUNDS accesses only. It contains no attacker
// training, no secret and no timing probe: it is not an exploit.
// Build:  gcc -O2 -DWRAPPED=0 bench.c -o bench_plain ;  gcc -O2 -DWRAPPED=1 bench.c -o bench_wrapped
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#ifndef WRAPPED
#define WRAPPED 0
#endif
#ifndef ITERS
#define ITERS 200000
#endif
static uint8_t array1[256], array2[256 * 512];
static volatile size_t array1_size = 256;
static volatile uint8_t sink;

static inline size_t sanitize(size_t x, size_t lim) {
#if WRAPPED && defined(__riscv)
    size_t m;
    __asm__ volatile("sltu %0, %1, %2\n\tneg %0, %0\n\tand %0, %1, %0\n\tfence rw, rw"
                     : "=&r"(m) : "r"(x), "r"(lim) : "memory");
    return m;
#else
    return x;
#endif
}
__attribute__((noinline)) uint8_t victim(size_t x) {
    size_t lim = array1_size;
    x = sanitize(x, lim);
    if (x < lim) return array2[array1[x] * 512];
    return 0;
}
int main(void) {
    for (int i = 0; i < 256; i++) array1[i] = (uint8_t)(i * 7);
    uint32_t s = 12345; uint8_t acc = 0;
    for (long i = 0; i < ITERS; i++) { s = s * 1664525u + 1013904223u; acc ^= victim(s & 255); }
    sink = acc; printf("%u\n", acc);
    return 0;
}
