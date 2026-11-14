# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a2, shared_line
    fence rw, rw
    rdcycle a6
    lbu t1, 0(a2)
    fence rw, rw
    rdcycle t4
    sub t4, t4, a6
    li t1, 120
    bltu t4, t1, hit
    li t1, 0
    j out
hit:
    li t1, 1
out:
    ret
