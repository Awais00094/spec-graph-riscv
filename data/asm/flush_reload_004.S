# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a3, shared_line
    fence rw, rw
    rdcycle t4
    lbu a7, 0(a3)
    fence rw, rw
    rdcycle a2
    sub a2, a2, t4
    li a7, 100
    bltu a2, a7, hit
    li a7, 0
    j out
hit:
    li a7, 1
out:
    ret
