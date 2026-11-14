# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t1, evset
    li a3, 0
    li a7, 8
    rdcycle a4
loop:
    lbu t0, 0(t1)
    addi t1, t1, 64
    addi a3, a3, 1
    blt a3, a7, loop
    rdcycle a6
    sub a6, a6, a4
    ret
