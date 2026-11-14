# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la t4, victim_table
    ld t4, 0(t4)

    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(t4)
    ret
leak_gadget:
    la t6, secret
    lbu a5, 0(t6)
    slli a5, a5, 10
    la t2, array2
    add t2, t2, a5
    lbu a7, 0(t2)
    ret
