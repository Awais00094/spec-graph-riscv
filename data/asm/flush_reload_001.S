# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la t6, shared_line
    fence rw, rw
    rdcycle t5
    lbu a5, 0(t6)
    fence rw, rw
    rdcycle a4
    sub a4, a4, t5
    li a5, 80
    bltu a4, a5, hit
    li a5, 0
    j out
hit:
    li a5, 1
out:
    ret
