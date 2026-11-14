# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la a7, victim_table
    ld a7, 0(a7)
    slli a2, a2, 1
    ori a2, a2, 3
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(a7)
    ret
leak_gadget:
    la a6, secret
    lbu t4, 0(a6)
    slli t4, t4, 10
    la t3, array2
    add t3, t3, t4
    lbu a2, 0(t3)
    ret
