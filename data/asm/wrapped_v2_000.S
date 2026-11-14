# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la a6, victim_table
    ld a6, 0(a6)
    xori t6, t6, 5
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(a6)
    ret
leak_gadget:
    la a2, secret
    lbu t0, 0(a2)
    slli t0, t0, 10
    la a5, array2
    add a5, a5, t0
    lbu t6, 0(a5)
    ret
