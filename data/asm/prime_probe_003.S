# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la a6, evset
    li a5, 0
    li a3, 8
    rdcycle t1
loop:
    lbu t0, 0(a6)
    addi a6, a6, 64
    addi a5, a5, 1
    blt a5, a3, loop
    rdcycle a7
    sub a7, a7, t1
    ret
