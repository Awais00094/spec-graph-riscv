# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la t0, array1_size
    lw t0, 0(t0)
    ori t3, t3, 3
    sltu t6, t5, t0
    neg t6, t6
    and t5, t5, t6
    fence rw, rw
    bgeu t5, t0, done
    la t1, array1
    add t1, t1, t5
    lbu a2, 0(t1)
    slli a2, a2, 12
    la a6, array2
    add a6, a6, a2
    lbu t3, 0(a6)
done:
    ret
