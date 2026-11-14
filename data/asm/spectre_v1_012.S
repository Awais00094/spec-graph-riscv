# template=spectre_v1 family=v1 label=1 wrapped=0
gadget:
    la a7, array1_size
    lw a7, 0(a7)
    ori t6, t6, 3
    addi t6, t6, 1
    xori t6, t6, 5
    bgeu a3, a7, done
    la a4, array1
    add a4, a4, a3
    lbu t1, 0(a4)
    slli t1, t1, 10
    la t2, array2
    add t2, t2, t1
    lbu t6, 0(t2)
done:
    ret
