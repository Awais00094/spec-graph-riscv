# template=spectre_v1 family=v1 label=1 wrapped=0
gadget:
    la a7, array1_size
    lw a7, 0(a7)
    slli a3, a3, 1
    ori a3, a3, 3
    addi a3, a3, 1
    bgeu t6, a7, done
    la t1, array1
    add t1, t1, t6
    lbu a2, 0(t1)
    slli a2, a2, 9
    la t3, array2
    add t3, t3, a2
    lbu a3, 0(t3)
done:
    ret
