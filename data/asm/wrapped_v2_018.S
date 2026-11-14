# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la a3, victim_table
    ld a3, 0(a3)

    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(a3)
    ret
leak_gadget:
    la a2, secret
    lbu a7, 0(a2)
    slli a7, a7, 10
    la a6, array2
    add a6, a6, a7
    lbu t5, 0(a6)
    ret
