# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la t0, victim_table
    ld t0, 0(t0)

    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(t0)
    ret
leak_gadget:
    la a7, secret
    lbu t1, 0(a7)
    slli t1, t1, 9
    la t6, array2
    add t6, t6, t1
    lbu t4, 0(t6)
    ret
