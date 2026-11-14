# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t0, evset
    li t6, 0
    li a3, 4
    rdcycle t3
loop:
    lbu t1, 0(t0)
    addi t0, t0, 128
    addi t6, t6, 1
    blt t6, a3, loop
    rdcycle a4
    sub a4, a4, t3
    ret
