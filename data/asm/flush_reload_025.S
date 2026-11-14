# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a4, shared_line
    fence rw, rw
    rdcycle t0
    lbu a6, 0(a4)
    fence rw, rw
    rdcycle t5
    sub t5, t5, t0
    li a6, 120
    bltu t5, a6, hit
    li a6, 0
    j out
hit:
    li a6, 1
out:
    ret
