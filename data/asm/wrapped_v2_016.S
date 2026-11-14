# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la a5, victim_table
    ld a5, 0(a5)
    xori t0, t0, 5
    slli t0, t0, 1
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(a5)
    ret
leak_gadget:
    la t3, secret
    lbu a3, 0(t3)
    slli a3, a3, 12
    la a2, array2
    add a2, a2, a3
    lbu t0, 0(a2)
    ret
