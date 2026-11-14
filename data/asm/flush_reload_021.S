# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a3, shared_line
    fence rw, rw
    rdcycle a2
    lbu a6, 0(a3)
    fence rw, rw
    rdcycle a5
    sub a5, a5, a2
    li a6, 80
    bltu a5, a6, hit
    li a6, 0
    j out
hit:
    li a6, 1
out:
    ret
