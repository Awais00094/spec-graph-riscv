# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t5, evset
    li t2, 0
    li a3, 8
    rdcycle a5
loop:
    lbu t1, 0(t5)
    addi t5, t5, 128
    addi t2, t2, 1
    blt t2, a3, loop
    rdcycle t0
    sub t0, t0, a5
    ret
