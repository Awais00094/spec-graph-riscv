# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la t4, victim_table
    ld t4, 0(t4)
    ori a6, a6, 3
    ori a6, a6, 3
    slli a6, a6, 1
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(t4)
    ret
leak_gadget:
    la t5, secret
    lbu a2, 0(t5)
    slli a2, a2, 10
    la t6, array2
    add t6, t6, a2
    lbu a6, 0(t6)
    ret
