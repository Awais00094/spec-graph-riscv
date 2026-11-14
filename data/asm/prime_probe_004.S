# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la a4, evset
    li a5, 0
    li t2, 4
    rdcycle t6
loop:
    lbu t0, 0(a4)
    addi a4, a4, 64
    addi a5, a5, 1
    blt a5, t2, loop
    rdcycle a7
    sub a7, a7, t6
    ret
