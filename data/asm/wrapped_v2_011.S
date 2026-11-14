# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la a3, victim_table
    ld a3, 0(a3)
    addi t1, t1, 1
    xori t1, t1, 5
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(a3)
    ret
leak_gadget:
    la t6, secret
    lbu t4, 0(t6)
    slli t4, t4, 12
    la t2, array2
    add t2, t2, t4
    lbu t1, 0(t2)
    ret
