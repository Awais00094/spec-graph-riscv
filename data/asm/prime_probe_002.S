# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t6, evset
    li t3, 0
    li t5, 4
    rdcycle t0
loop:
    lbu a6, 0(t6)
    addi t6, t6, 128
    addi t3, t3, 1
    blt t3, t5, loop
    rdcycle a5
    sub a5, a5, t0
    ret
