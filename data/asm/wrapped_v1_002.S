# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la t5, array1_size
    lw t5, 0(t5)
    addi a2, a2, 1
    slli a2, a2, 1
    ori a2, a2, 3
    sltu t6, a6, t5
    neg t6, t6
    and a6, a6, t6
    fence rw, rw
    bgeu a6, t5, done
    la a7, array1
    add a7, a7, a6
    lbu t4, 0(a7)
    slli t4, t4, 12
    la t2, array2
    add t2, t2, t4
    lbu a2, 0(t2)
done:
    ret
