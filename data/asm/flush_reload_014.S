# template=flush_reload family=cache_probe label=1 wrapped=0
probe:
    la t2, shared_line
    fence rw, rw
    rdcycle a5
    lbu t3, 0(t2)
    fence rw, rw
    rdcycle t5
    sub t5, t5, a5
    li t3, 80
    bltu t5, t3, hit
    li t3, 0
    j out
hit:
    li t3, 1
out:
    ret
