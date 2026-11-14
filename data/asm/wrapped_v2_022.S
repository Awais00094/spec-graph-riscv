# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la t6, victim_table
    ld t6, 0(t6)
    ori t4, t4, 3
    ori t4, t4, 3
    xori t4, t4, 5
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(t6)
    ret
leak_gadget:
    la a3, secret
    lbu a7, 0(a3)
    slli a7, a7, 9
    la a6, array2
    add a6, a6, a7
    lbu t4, 0(a6)
    ret
