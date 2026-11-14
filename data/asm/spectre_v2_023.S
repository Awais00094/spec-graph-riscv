# template=spectre_v2 family=v2 label=1 wrapped=0
gadget:
    la a6, victim_table
    ld a6, 0(a6)
    ori t1, t1, 3
    jalr ra, 0(a6)
    ret
leak_gadget:
    la t3, secret
    lbu t2, 0(t3)
    slli t2, t2, 12
    la a3, array2
    add a3, a3, t2
    lbu t1, 0(a3)
    ret
