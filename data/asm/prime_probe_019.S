# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t0, evset
    li a7, 0
    li a2, 4
    rdcycle a6
loop:
    lbu a3, 0(t0)
    addi t0, t0, 64
    addi a7, a7, 1
    blt a7, a2, loop
    rdcycle t5
    sub t5, t5, a6
    ret
