# template=prime_probe family=cache_probe label=1 wrapped=0
probe_set:
    la t5, evset
    li a4, 0
    li t6, 8
    rdcycle t0
loop:
    lbu t4, 0(t5)
    addi t5, t5, 64
    addi a4, a4, 1
    blt a4, t6, loop
    rdcycle a5
    sub a5, a5, t0
    ret
