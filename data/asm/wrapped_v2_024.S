# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la a6, victim_table
    ld a6, 0(a6)
    addi a7, a7, 1
    ori a7, a7, 3
    addi a7, a7, 1
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(a6)
    ret
leak_gadget:
    la a4, secret
    lbu t0, 0(a4)
    slli t0, t0, 10
    la t3, array2
    add t3, t3, t0
    lbu a7, 0(t3)
    ret
