# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la t2, shared_line
    fence rw, rw
    rdcycle a3
    lbu a5, 0(t2)
    fence rw, rw
    rdcycle a6
    sub a6, a6, a3
    li a5, 120
    bltu a6, a5, hit
    li a5, 0
    j out
hit:
    li a5, 1
out:
    ret
