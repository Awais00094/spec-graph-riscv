# template=spectre_v2 family=v2 label=1 wrapped=0
gadget:
    la a3, victim_table
    ld a3, 0(a3)

    jalr ra, 0(a3)
    ret
leak_gadget:
    la t2, secret
    lbu t5, 0(t2)
    slli t5, t5, 10
    la a6, array2
    add a6, a6, t5
    lbu t0, 0(a6)
    ret
