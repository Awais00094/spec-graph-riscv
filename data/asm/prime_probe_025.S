# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t2, evset
    li t3, 0
    li a4, 8
    rdcycle a7
loop:
    lbu t6, 0(t2)
    addi t2, t2, 64
    addi t3, t3, 1
    blt t3, a4, loop
    rdcycle a2
    sub a2, a2, a7
    ret
