# template=spectre_v2 family=v2 label=1 wrapped=0
gadget:
    la a4, victim_table
    ld a4, 0(a4)
    addi a7, a7, 1
    jalr ra, 0(a4)
    ret
leak_gadget:
    la t3, secret
    lbu t4, 0(t3)
    slli t4, t4, 10
    la t0, array2
    add t0, t0, t4
    lbu a7, 0(t0)
    ret
