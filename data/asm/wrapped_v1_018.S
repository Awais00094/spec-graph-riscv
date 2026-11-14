# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la t1, array1_size
    lw t1, 0(t1)
    addi t4, t4, 1
    sltu a4, a2, t1
    neg a4, a4
    and a2, a2, a4
    fence rw, rw
    bgeu a2, t1, done
    la t5, array1
    add t5, t5, a2
    lbu a5, 0(t5)
    slli a5, a5, 12
    la t2, array2
    add t2, t2, a5
    lbu t4, 0(t2)
done:
    ret
