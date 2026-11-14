# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la a6, array1_size
    lw a6, 0(a6)
    xori t1, t1, 5
    slli t1, t1, 1
    addi t1, t1, 1
    sltu a4, t4, a6
    neg a4, a4
    and t4, t4, a4
    fence rw, rw
    bgeu t4, a6, done
    la t6, array1
    add t6, t6, t4
    lbu t5, 0(t6)
    slli t5, t5, 9
    la a7, array2
    add a7, a7, t5
    lbu t1, 0(a7)
done:
    ret
