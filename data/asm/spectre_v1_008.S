# template=spectre_v1 family=v1 label=1 wrapped=0
gadget:
    la t0, array1_size
    lw t0, 0(t0)
    ori t3, t3, 3
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
