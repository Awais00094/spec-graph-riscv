# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t0, evset
    li t5, 0
    li a4, 4
    rdcycle t3
loop:
    lbu a3, 0(t0)
    addi t0, t0, 64
    addi t5, t5, 1
    blt t5, a4, loop
    rdcycle a7
    sub a7, a7, t3
    ret
