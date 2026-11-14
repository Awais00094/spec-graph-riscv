# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la a6, victim_table
    ld a6, 0(a6)
    ori a2, a2, 3
    ori a2, a2, 3
    addi a2, a2, 1
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(a6)
    ret
leak_gadget:
    la a4, secret
    lbu t0, 0(a4)
    slli t0, t0, 9
    la t2, array2
    add t2, t2, t0
    lbu a2, 0(t2)
    ret
