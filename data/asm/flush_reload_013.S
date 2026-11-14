# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la a2, shared_line
    fence rw, rw
    rdcycle t3
    lbu t6, 0(a2)
    fence rw, rw
    rdcycle t0
    sub t0, t0, t3
    li t6, 100
    bltu t0, t6, hit
    li t6, 0
    j out
hit:
    li t6, 1
out:
    ret
