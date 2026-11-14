# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la a2, array1_size
    lw a2, 0(a2)

    sltu t5, t0, a2
    neg t5, t5
    and t0, t0, t5
    fence rw, rw
    bgeu t0, a2, done
    la t4, array1
    add t4, t4, t0
    lbu a4, 0(t4)
    slli a4, a4, 10
    la t6, array2
    add t6, t6, a4
    lbu t2, 0(t6)
done:
    ret
