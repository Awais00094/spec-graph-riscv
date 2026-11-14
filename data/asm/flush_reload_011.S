# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a4, shared_line
    fence rw, rw
    rdcycle a6
    lbu t5, 0(a4)
    fence rw, rw
    rdcycle t3
    sub t3, t3, a6
    li t5, 100
    bltu t3, t5, hit
    li t5, 0
    j out
hit:
    li t5, 1
out:
    ret
