# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la t3, array1_size
    lw t3, 0(t3)
    xori t6, t6, 5
    ori t6, t6, 3
    xori t6, t6, 5
    sltu a2, t0, t3
    neg a2, a2
    and t0, t0, a2
    fence rw, rw
    bgeu t0, t3, done
    la a7, array1
    add a7, a7, t0
    lbu t1, 0(a7)
    slli t1, t1, 12
    la t2, array2
    add t2, t2, t1
    lbu t6, 0(t2)
done:
    ret
