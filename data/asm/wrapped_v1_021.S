# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la a6, array1_size
    lw a6, 0(a6)

    sltu a2, t0, a6
    neg a2, a2
    and t0, t0, a2
    fence rw, rw
    bgeu t0, a6, done
    la t1, array1
    add t1, t1, t0
    lbu a7, 0(t1)
    slli a7, a7, 12
    la t4, array2
    add t4, t4, a7
    lbu t2, 0(t4)
done:
    ret
