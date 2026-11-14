# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la t3, array1_size
    lw t3, 0(t3)

    sltu t4, a2, t3
    neg t4, t4
    and a2, a2, t4
    fence rw, rw
    bgeu a2, t3, done
    la a4, array1
    add a4, a4, a2
    lbu t2, 0(a4)
    slli t2, t2, 10
    la t6, array2
    add t6, t6, t2
    lbu a3, 0(t6)
done:
    ret
