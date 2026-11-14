# template=spectre_v2 family=v2 label=1 wrapped=0
gadget:
    la a4, victim_table
    ld a4, 0(a4)
    addi a6, a6, 1
    slli a6, a6, 1
    slli a6, a6, 1
    jalr ra, 0(a4)
    ret
leak_gadget:
    la a3, secret
    lbu t0, 0(a3)
    slli t0, t0, 12
    la a2, array2
    add a2, a2, t0
    lbu a6, 0(a2)
    ret
