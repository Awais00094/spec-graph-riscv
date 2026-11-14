# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t5, evset
    li a6, 0
    li a5, 4
    rdcycle a7
loop:
    lbu t6, 0(t5)
    addi t5, t5, 4096
    addi a6, a6, 1
    blt a6, a5, loop
    rdcycle t0
    sub t0, t0, a7
    ret
