# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la t0, victim_table
    ld t0, 0(t0)

    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(t0)
    ret
leak_gadget:
    la a2, secret
    lbu a5, 0(a2)
    slli a5, a5, 12
    la t5, array2
    add t5, t5, a5
    lbu t4, 0(t5)
    ret
