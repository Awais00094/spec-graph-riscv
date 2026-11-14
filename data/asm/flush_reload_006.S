# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la t3, shared_line
    fence rw, rw
    rdcycle a2
    lbu t1, 0(t3)
    fence rw, rw
    rdcycle t0
    sub t0, t0, a2
    li t1, 120
    bltu t0, t1, hit
    li t1, 0
    j out
hit:
    li t1, 1
out:
    ret
