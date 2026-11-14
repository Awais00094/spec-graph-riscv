# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la t1, shared_line
    fence rw, rw
    rdcycle t6
    lbu t0, 0(t1)
    fence rw, rw
    rdcycle t4
    sub t4, t4, t6
    li t0, 120
    bltu t4, t0, hit
    li t0, 0
    j out
hit:
    li t0, 1
out:
    ret
