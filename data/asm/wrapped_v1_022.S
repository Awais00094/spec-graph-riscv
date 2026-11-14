# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la a2, array1_size
    lw a2, 0(a2)
    ori t1, t1, 3
    sltu t6, a5, a2
    neg t6, t6
    and a5, a5, t6
    fence rw, rw
    bgeu a5, a2, done
    la a3, array1
    add a3, a3, a5
    lbu t3, 0(a3)
    slli t3, t3, 9
    la t4, array2
    add t4, t4, t3
    lbu t1, 0(t4)
done:
    ret
