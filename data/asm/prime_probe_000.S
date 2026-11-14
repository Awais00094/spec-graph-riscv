# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t5, evset
    li a3, 0
    li a2, 8
    rdcycle a4
loop:
    lbu a6, 0(t5)
    addi t5, t5, 64
    addi a3, a3, 1
    blt a3, a2, loop
    rdcycle a7
    sub a7, a7, a4
    ret
