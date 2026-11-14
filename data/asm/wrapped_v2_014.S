# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la a4, victim_table
    ld a4, 0(a4)
    addi a7, a7, 1
    slli a7, a7, 1
    addi a7, a7, 1
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(a4)
    ret
leak_gadget:
    la t5, secret
    lbu t0, 0(t5)
    slli t0, t0, 12
    la a2, array2
    add a2, a2, t0
    lbu a7, 0(a2)
    ret
