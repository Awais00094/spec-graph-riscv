# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t5, evset
    li t4, 0
    li t1, 4
    rdcycle t3
loop:
    lbu t6, 0(t5)
    addi t5, t5, 128
    addi t4, t4, 1
    blt t4, t1, loop
    rdcycle t0
    sub t0, t0, t3
    ret
