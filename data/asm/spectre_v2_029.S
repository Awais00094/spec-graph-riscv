# template=spectre_v2 family=v2 label=1 wrapped=0
gadget:
    la t2, victim_table
    ld t2, 0(t2)
    xori a2, a2, 5
    slli a2, a2, 1
    jalr ra, 0(t2)
    ret
leak_gadget:
    la a5, secret
    lbu t3, 0(a5)
    slli t3, t3, 12
    la t6, array2
    add t6, t6, t3
    lbu a2, 0(t6)
    ret
