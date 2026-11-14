# template=spectre_v2 family=v2 label=1 wrapped=0
gadget:
    la a6, victim_table
    ld a6, 0(a6)

    jalr ra, 0(a6)
    ret
leak_gadget:
    la t3, secret
    lbu t1, 0(t3)
    slli t1, t1, 12
    la a3, array2
    add a3, a3, t1
    lbu a5, 0(a3)
    ret
