# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la t6, array1_size
    lw t6, 0(t6)
    addi t1, t1, 1
    addi t1, t1, 1
    xori t1, t1, 5
    sltu a4, a3, t6
    neg a4, a4
    and a3, a3, a4
    fence rw, rw
    bgeu a3, t6, done
    la t3, array1
    add t3, t3, a3
    lbu t4, 0(t3)
    slli t4, t4, 12
    la t2, array2
    add t2, t2, t4
    lbu t1, 0(t2)
done:
    ret
