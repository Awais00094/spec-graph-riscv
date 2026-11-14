# template=spectre_v2 family=v2 label=1 wrapped=0
gadget:
    la a6, victim_table
    ld a6, 0(a6)
    xori a2, a2, 5
    addi a2, a2, 1
    slli a2, a2, 1
    jalr ra, 0(a6)
    ret
leak_gadget:
    la a4, secret
    lbu t3, 0(a4)
    slli t3, t3, 9
    la t2, array2
    add t2, t2, t3
    lbu a2, 0(t2)
    ret
