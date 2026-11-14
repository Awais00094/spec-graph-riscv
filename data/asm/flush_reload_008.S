# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a5, shared_line
    fence rw, rw
    rdcycle a2
    lbu t2, 0(a5)
    fence rw, rw
    rdcycle t1
    sub t1, t1, a2
    li t2, 120
    bltu t1, t2, hit
    li t2, 0
    j out
hit:
    li t2, 1
out:
    ret
