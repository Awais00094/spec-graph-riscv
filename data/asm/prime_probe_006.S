# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t6, evset
    li t3, 0
    li a7, 8
    rdcycle a5
loop:
    lbu t1, 0(t6)
    addi t6, t6, 4096
    addi t3, t3, 1
    blt t3, a7, loop
    rdcycle a3
    sub a3, a3, a5
    ret
