# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la a7, evset
    li a2, 0
    li t2, 4
    rdcycle t5
loop:
    lbu t6, 0(a7)
    addi a7, a7, 64
    addi a2, a2, 1
    blt a2, t2, loop
    rdcycle a6
    sub a6, a6, t5
    ret
