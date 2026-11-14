# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a6, shared_line
    fence rw, rw
    rdcycle t3
    lbu t1, 0(a6)
    fence rw, rw
    rdcycle t4
    sub t4, t4, t3
    li t1, 100
    bltu t4, t1, hit
    li t1, 0
    j out
hit:
    li t1, 1
out:
    ret
