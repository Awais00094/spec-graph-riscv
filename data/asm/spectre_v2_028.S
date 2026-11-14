# template=spectre_v2 family=v2 label=1 wrapped=0
gadget:
    la t3, victim_table
    ld t3, 0(t3)
    ori a3, a3, 3
    slli a3, a3, 1
    addi a3, a3, 1
    jalr ra, 0(t3)
    ret
leak_gadget:
    la t2, secret
    lbu t6, 0(t2)
    slli t6, t6, 10
    la a7, array2
    add a7, a7, t6
    lbu a3, 0(a7)
    ret
