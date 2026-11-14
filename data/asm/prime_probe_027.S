# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t0, evset
    li a4, 0
    li a2, 4
    rdcycle t3
loop:
    lbu t1, 0(t0)
    addi t0, t0, 128
    addi a4, a4, 1
    blt a4, a2, loop
    rdcycle t2
    sub t2, t2, t3
    ret
