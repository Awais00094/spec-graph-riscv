# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t2, evset
    li t5, 0
    li t1, 4
    rdcycle a5
loop:
    lbu t0, 0(t2)
    addi t2, t2, 4096
    addi t5, t5, 1
    blt t5, t1, loop
    rdcycle t6
    sub t6, t6, a5
    ret
