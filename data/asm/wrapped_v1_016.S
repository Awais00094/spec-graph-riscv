# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la t1, array1_size
    lw t1, 0(t1)
    ori t2, t2, 3
    sltu a5, a6, t1
    neg a5, a5
    and a6, a6, a5
    fence rw, rw
    bgeu a6, t1, done
    la t6, array1
    add t6, t6, a6
    lbu a2, 0(t6)
    slli a2, a2, 12
    la t3, array2
    add t3, t3, a2
    lbu t2, 0(t3)
done:
    ret
