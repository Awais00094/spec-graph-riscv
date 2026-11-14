# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t2, evset
    li a7, 0
    li a2, 4
    rdcycle t0
loop:
    lbu a4, 0(t2)
    addi t2, t2, 4096
    addi a7, a7, 1
    blt a7, a2, loop
    rdcycle t5
    sub t5, t5, t0
    ret
