# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a3, shared_line
    fence rw, rw
    rdcycle t1
    lbu a4, 0(a3)
    fence rw, rw
    rdcycle t0
    sub t0, t0, t1
    li a4, 80
    bltu t0, a4, hit
    li a4, 0
    j out
hit:
    li a4, 1
out:
    ret
