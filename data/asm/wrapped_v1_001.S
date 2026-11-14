# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la t4, array1_size
    lw t4, 0(t4)
    xori a7, a7, 5
    slli a7, a7, 1
    ori a7, a7, 3
    sltu a2, t0, t4
    neg a2, a2
    and t0, t0, a2
    fence rw, rw
    bgeu t0, t4, done
    la t6, array1
    add t6, t6, t0
    lbu a5, 0(t6)
    slli a5, a5, 10
    la t5, array2
    add t5, t5, a5
    lbu a7, 0(t5)
done:
    ret
