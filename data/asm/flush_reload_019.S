# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a3, shared_line
    fence rw, rw
    rdcycle t0
    lbu a7, 0(a3)
    fence rw, rw
    rdcycle a4
    sub a4, a4, t0
    li a7, 80
    bltu a4, a7, hit
    li a7, 0
    j out
hit:
    li a7, 1
out:
    ret
