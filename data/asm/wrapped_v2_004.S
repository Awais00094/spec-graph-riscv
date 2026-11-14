# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la a2, victim_table
    ld a2, 0(a2)
    addi a7, a7, 1
    xori a7, a7, 5
    addi a7, a7, 1
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(a2)
    ret
leak_gadget:
    la t4, secret
    lbu t5, 0(t4)
    slli t5, t5, 10
    la a6, array2
    add a6, a6, t5
    lbu a7, 0(a6)
    ret
