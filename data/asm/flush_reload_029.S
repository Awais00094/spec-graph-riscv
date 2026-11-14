# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a4, shared_line
    fence rw, rw
    rdcycle a3
    lbu a7, 0(a4)
    fence rw, rw
    rdcycle t2
    sub t2, t2, a3
    li a7, 120
    bltu t2, a7, hit
    li a7, 0
    j out
hit:
    li a7, 1
out:
    ret
