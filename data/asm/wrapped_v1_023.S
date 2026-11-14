# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la a7, array1_size
    lw a7, 0(a7)

    sltu a4, t0, a7
    neg a4, a4
    and t0, t0, a4
    fence rw, rw
    bgeu t0, a7, done
    la a5, array1
    add a5, a5, t0
    lbu t4, 0(a5)
    slli t4, t4, 9
    la a6, array2
    add a6, a6, t4
    lbu a2, 0(a6)
done:
    ret
