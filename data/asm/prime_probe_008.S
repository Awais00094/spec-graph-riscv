# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la a7, evset
    li a5, 0
    li t3, 8
    rdcycle t2
loop:
    lbu t0, 0(a7)
    addi a7, a7, 128
    addi a5, a5, 1
    blt a5, t3, loop
    rdcycle a3
    sub a3, a3, t2
    ret
