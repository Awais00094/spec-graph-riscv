# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a5, shared_line
    fence rw, rw
    rdcycle a4
    lbu t2, 0(a5)
    fence rw, rw
    rdcycle a7
    sub a7, a7, a4
    li t2, 100
    bltu a7, t2, hit
    li t2, 0
    j out
hit:
    li t2, 1
out:
    ret
