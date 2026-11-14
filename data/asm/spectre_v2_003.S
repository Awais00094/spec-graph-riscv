# template=spectre_v2 family=v2 label=1 wrapped=0
gadget:
    la a6, victim_table
    ld a6, 0(a6)
    xori t3, t3, 5
    jalr ra, 0(a6)
    ret
leak_gadget:
    la a2, secret
    lbu a7, 0(a2)
    slli a7, a7, 12
    la t5, array2
    add t5, t5, a7
    lbu t3, 0(t5)
    ret
