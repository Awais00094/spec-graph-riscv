# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a4, shared_line
    fence rw, rw
    rdcycle a5
    lbu t0, 0(a4)
    fence rw, rw
    rdcycle t1
    sub t1, t1, a5
    li t0, 80
    bltu t1, t0, hit
    li t0, 0
    j out
hit:
    li t0, 1
out:
    ret
