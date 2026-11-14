# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t2, evset
    li a7, 0
    li a3, 4
    rdcycle t1
loop:
    lbu a4, 0(t2)
    addi t2, t2, 128
    addi a7, a7, 1
    blt a7, a3, loop
    rdcycle t6
    sub t6, t6, t1
    ret
