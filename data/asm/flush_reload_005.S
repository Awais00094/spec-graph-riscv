# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la t0, shared_line
    fence rw, rw
    rdcycle a3
    lbu a6, 0(t0)
    fence rw, rw
    rdcycle a2
    sub a2, a2, a3
    li a6, 80
    bltu a2, a6, hit
    li a6, 0
    j out
hit:
    li a6, 1
out:
    ret
