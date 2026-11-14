# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a7, shared_line
    fence rw, rw
    rdcycle a3
    lbu t1, 0(a7)
    fence rw, rw
    rdcycle a4
    sub a4, a4, a3
    li t1, 100
    bltu a4, t1, hit
    li t1, 0
    j out
hit:
    li t1, 1
out:
    ret
