# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la t5, shared_line
    fence rw, rw
    rdcycle t6
    lbu a3, 0(t5)
    fence rw, rw
    rdcycle a5
    sub a5, a5, t6
    li a3, 80
    bltu a5, a3, hit
    li a3, 0
    j out
hit:
    li a3, 1
out:
    ret
