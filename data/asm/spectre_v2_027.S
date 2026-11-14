# template=spectre_v2 family=v2 label=1 wrapped=0
gadget:
    la t3, victim_table
    ld t3, 0(t3)
    addi a3, a3, 1
    xori a3, a3, 5
    slli a3, a3, 1
    jalr ra, 0(t3)
    ret
leak_gadget:
    la t2, secret
    lbu a5, 0(t2)
    slli a5, a5, 10
    la t0, array2
    add t0, t0, a5
    lbu a3, 0(t0)
    ret
