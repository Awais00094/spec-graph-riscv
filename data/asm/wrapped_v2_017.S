# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la t1, victim_table
    ld t1, 0(t1)

    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(t1)
    ret
leak_gadget:
    la a7, secret
    lbu a4, 0(a7)
    slli a4, a4, 10
    la a2, array2
    add a2, a2, a4
    lbu t5, 0(a2)
    ret
