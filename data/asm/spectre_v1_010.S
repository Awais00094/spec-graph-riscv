# template=spectre_v1 family=v1 label=1 wrapped=0
gadget:
    la a7, array1_size
    lw a7, 0(a7)
    xori a4, a4, 5
    addi a4, a4, 1
    addi a4, a4, 1
    bgeu t6, a7, done
    la t2, array1
    add t2, t2, t6
    lbu t1, 0(t2)
    slli t1, t1, 12
    la a6, array2
    add a6, a6, t1
    lbu a4, 0(a6)
done:
    ret
