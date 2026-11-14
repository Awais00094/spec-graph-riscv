# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la t6, array1_size
    lw t6, 0(t6)

    sltu t4, t3, t6
    neg t4, t4
    and t3, t3, t4
    fence rw, rw
    bgeu t3, t6, done
    la a2, array1
    add a2, a2, t3
    lbu t0, 0(a2)
    slli t0, t0, 12
    la a6, array2
    add a6, a6, t0
    lbu a4, 0(a6)
done:
    ret
