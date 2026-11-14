# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la t5, shared_line
    fence rw, rw
    rdcycle a4
    lbu t2, 0(t5)
    fence rw, rw
    rdcycle a3
    sub a3, a3, a4
    li t2, 80
    bltu a3, t2, hit
    li t2, 0
    j out
hit:
    li t2, 1
out:
    ret
