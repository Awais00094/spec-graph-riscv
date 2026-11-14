# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la a2, victim_table
    ld a2, 0(a2)
    ori t0, t0, 3
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(a2)
    ret
leak_gadget:
    la a4, secret
    lbu a6, 0(a4)
    slli a6, a6, 9
    la a3, array2
    add a3, a3, a6
    lbu t0, 0(a3)
    ret
