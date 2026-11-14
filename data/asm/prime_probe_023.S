# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t5, evset
    li t1, 0
    li a7, 4
    rdcycle t4
loop:
    lbu a6, 0(t5)
    addi t5, t5, 128
    addi t1, t1, 1
    blt t1, a7, loop
    rdcycle t3
    sub t3, t3, t4
    ret
