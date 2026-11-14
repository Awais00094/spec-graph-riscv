# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la t1, array1_size
    lw t1, 0(t1)

    sltu t0, a4, t1
    neg t0, t0
    and a4, a4, t0
    fence rw, rw
    bgeu a4, t1, done
    la t3, array1
    add t3, t3, a4
    lbu a7, 0(t3)
    slli a7, a7, 9
    la t5, array2
    add t5, t5, a7
    lbu a5, 0(t5)
done:
    ret
