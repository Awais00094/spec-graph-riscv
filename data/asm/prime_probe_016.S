# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t3, evset
    li t1, 0
    li a2, 4
    rdcycle a4
loop:
    lbu a3, 0(t3)
    addi t3, t3, 128
    addi t1, t1, 1
    blt t1, a2, loop
    rdcycle a6
    sub a6, a6, a4
    ret
