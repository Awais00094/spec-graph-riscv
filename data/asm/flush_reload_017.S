# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la t6, shared_line
    fence rw, rw
    rdcycle t3
    lbu t5, 0(t6)
    fence rw, rw
    rdcycle a7
    sub a7, a7, t3
    li t5, 80
    bltu a7, t5, hit
    li t5, 0
    j out
hit:
    li t5, 1
out:
    ret
