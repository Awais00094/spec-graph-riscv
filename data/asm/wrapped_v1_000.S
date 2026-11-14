# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la a6, array1_size
    lw a6, 0(a6)
    slli a5, a5, 1
    addi a5, a5, 1
    sltu a4, a7, a6
    neg a4, a4
    and a7, a7, a4
    fence rw, rw
    bgeu a7, a6, done
    la t2, array1
    add t2, t2, a7
    lbu t6, 0(t2)
    slli t6, t6, 12
    la a3, array2
    add a3, a3, t6
    lbu a5, 0(a3)
done:
    ret
