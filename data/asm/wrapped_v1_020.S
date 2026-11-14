# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la t2, array1_size
    lw t2, 0(t2)
    addi a3, a3, 1
    sltu a4, t5, t2
    neg a4, a4
    and t5, t5, a4
    fence rw, rw
    bgeu t5, t2, done
    la t0, array1
    add t0, t0, t5
    lbu t6, 0(t0)
    slli t6, t6, 9
    la t4, array2
    add t4, t4, t6
    lbu a3, 0(t4)
done:
    ret
