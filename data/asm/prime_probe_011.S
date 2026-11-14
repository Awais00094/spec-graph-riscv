# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t5, evset
    li t4, 0
    li a3, 4
    rdcycle a5
loop:
    lbu a4, 0(t5)
    addi t5, t5, 64
    addi t4, t4, 1
    blt t4, a3, loop
    rdcycle a2
    sub a2, a2, a5
    ret
