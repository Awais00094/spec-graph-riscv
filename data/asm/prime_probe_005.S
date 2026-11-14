# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t0, evset
    li a6, 0
    li t1, 4
    rdcycle a7
loop:
    lbu t2, 0(t0)
    addi t0, t0, 4096
    addi a6, a6, 1
    blt a6, t1, loop
    rdcycle t4
    sub t4, t4, a7
    ret
