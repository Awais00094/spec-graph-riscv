# template=wrapped_v2 family=v2 label=0 wrapped=1
gadget:
    la a6, victim_table
    ld a6, 0(a6)

    fence rw, rw
    fence iorw, iorw
    jalr ra, 0(a6)
    ret
leak_gadget:
    la a4, secret
    lbu t0, 0(a4)
    slli t0, t0, 10
    la t1, array2
    add t1, t1, t0
    lbu t3, 0(t1)
    ret
