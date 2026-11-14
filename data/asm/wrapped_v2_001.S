# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la t6, victim_table
    ld t6, 0(t6)
    ori a4, a4, 3
    xori a4, a4, 5
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(t6)
    ret
leak_gadget:
    la t5, secret
    lbu t0, 0(t5)
    slli t0, t0, 12
    la a6, array2
    add a6, a6, t0
    lbu a4, 0(a6)
    ret
