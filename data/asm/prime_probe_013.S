# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t4, evset
    li t0, 0
    li a4, 4
    rdcycle t3
loop:
    lbu a7, 0(t4)
    addi t4, t4, 128
    addi t0, t0, 1
    blt t0, a4, loop
    rdcycle t5
    sub t5, t5, t3
    ret
