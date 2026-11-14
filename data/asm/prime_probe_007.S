# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t6, evset
    li a7, 0
    li t2, 4
    rdcycle a3
loop:
    lbu a2, 0(t6)
    addi t6, t6, 4096
    addi a7, a7, 1
    blt a7, t2, loop
    rdcycle t0
    sub t0, t0, a3
    ret
