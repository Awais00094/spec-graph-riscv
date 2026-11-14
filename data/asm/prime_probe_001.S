# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t2, evset
    li t0, 0
    li a5, 8
    rdcycle a4
loop:
    lbu a3, 0(t2)
    addi t2, t2, 128
    addi t0, t0, 1
    blt t0, a5, loop
    rdcycle a7
    sub a7, a7, a4
    ret
