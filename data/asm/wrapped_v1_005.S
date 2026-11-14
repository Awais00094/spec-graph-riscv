# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la a6, array1_size
    lw a6, 0(a6)
    addi t5, t5, 1
    xori t5, t5, 5
    ori t5, t5, 3
    sltu t4, t3, a6
    neg t4, t4
    and t3, t3, t4
    fence rw, rw
    bgeu t3, a6, done
    la a7, array1
    add a7, a7, t3
    lbu t6, 0(a7)
    slli t6, t6, 10
    la t0, array2
    add t0, t0, t6
    lbu t5, 0(t0)
done:
    ret
