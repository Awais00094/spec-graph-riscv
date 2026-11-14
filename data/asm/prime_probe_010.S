# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t1, evset
    li a2, 0
    li a3, 4
    rdcycle t2
loop:
    lbu t4, 0(t1)
    addi t1, t1, 128
    addi a2, a2, 1
    blt a2, a3, loop
    rdcycle t5
    sub t5, t5, t2
    ret
