# template=spectre_v2 family=v2 label=1 wrapped=0
gadget:
    la t4, victim_table
    ld t4, 0(t4)
    xori a3, a3, 5
    jalr ra, 0(t4)
    ret
leak_gadget:
    la a7, secret
    lbu t3, 0(a7)
    slli t3, t3, 12
    la t1, array2
    add t1, t1, t3
    lbu a3, 0(t1)
    ret
