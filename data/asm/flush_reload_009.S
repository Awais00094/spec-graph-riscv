# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la t6, shared_line
    fence rw, rw
    rdcycle t3
    lbu a3, 0(t6)
    fence rw, rw
    rdcycle a4
    sub a4, a4, t3
    li a3, 120
    bltu a4, a3, hit
    li a3, 0
    j out
hit:
    li a3, 1
out:
    ret
