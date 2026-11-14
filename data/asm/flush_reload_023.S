# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a6, shared_line
    fence rw, rw
    rdcycle t5
    lbu t4, 0(a6)
    fence rw, rw
    rdcycle a7
    sub a7, a7, t5
    li t4, 80
    bltu a7, t4, hit
    li t4, 0
    j out
hit:
    li t4, 1
out:
    ret
