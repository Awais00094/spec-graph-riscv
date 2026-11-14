# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a4, shared_line
    fence rw, rw
    rdcycle a5
    lbu t5, 0(a4)
    fence rw, rw
    rdcycle a7
    sub a7, a7, a5
    li t5, 100
    bltu a7, t5, hit
    li t5, 0
    j out
hit:
    li t5, 1
out:
    ret
