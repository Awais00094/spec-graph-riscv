# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la t3, shared_line
    fence rw, rw
    rdcycle t0
    lbu t5, 0(t3)
    fence rw, rw
    rdcycle t2
    sub t2, t2, t0
    li t5, 100
    bltu t2, t5, hit
    li t5, 0
    j out
hit:
    li t5, 1
out:
    ret
