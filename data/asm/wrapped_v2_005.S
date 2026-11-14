# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la t1, victim_table
    ld t1, 0(t1)
    addi t6, t6, 1
    ori t6, t6, 3
    xori t6, t6, 5
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(t1)
    ret
leak_gadget:
    la t2, secret
    lbu t5, 0(t2)
    slli t5, t5, 12
    la a4, array2
    add a4, a4, t5
    lbu t6, 0(a4)
    ret
