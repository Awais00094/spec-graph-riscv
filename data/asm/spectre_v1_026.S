# template=spectre_v1 family=v1 label=1 wrapped=0
gadget:
    la t1, array1_size
    lw t1, 0(t1)
    ori t0, t0, 3
    addi t0, t0, 1
    xori t0, t0, 5
    bgeu a5, t1, done
    la a7, array1
    add a7, a7, a5
    lbu a4, 0(a7)
    slli a4, a4, 10
    la t2, array2
    add t2, t2, a4
    lbu t0, 0(t2)
done:
    ret
