# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la a5, evset
    li t5, 0
    li a6, 4
    rdcycle a7
loop:
    lbu a3, 0(a5)
    addi a5, a5, 4096
    addi t5, t5, 1
    blt t5, a6, loop
    rdcycle t4
    sub t4, t4, a7
    ret
