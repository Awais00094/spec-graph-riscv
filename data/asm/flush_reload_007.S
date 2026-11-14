# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a7, shared_line
    fence rw, rw
    rdcycle t4
    lbu t6, 0(a7)
    fence rw, rw
    rdcycle a2
    sub a2, a2, t4
    li t6, 80
    bltu a2, t6, hit
    li t6, 0
    j out
hit:
    li t6, 1
out:
    ret
