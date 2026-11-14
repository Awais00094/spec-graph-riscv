# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la a4, array1_size
    lw a4, 0(a4)

    sltu t6, t1, a4
    neg t6, t6
    and t1, t1, t6
    fence rw, rw
    bgeu t1, a4, done
    la a7, array1
    add a7, a7, t1
    lbu a6, 0(a7)
    slli a6, a6, 12
    la t3, array2
    add t3, t3, a6
    lbu t2, 0(t3)
done:
    ret
