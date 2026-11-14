# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t1, evset
    li t5, 0
    li t0, 8
    rdcycle a3
loop:
    lbu t6, 0(t1)
    addi t1, t1, 128
    addi t5, t5, 1
    blt t5, t0, loop
    rdcycle a7
    sub a7, a7, a3
    ret
