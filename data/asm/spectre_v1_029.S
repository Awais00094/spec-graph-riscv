# template=spectre_v1 family=v1 label=1 wrapped=0
gadget:
    la t6, array1_size
    lw t6, 0(t6)
    ori a6, a6, 3
    bgeu a2, t6, done
    la a4, array1
    add a4, a4, a2
    lbu t5, 0(a4)
    slli t5, t5, 9
    la a3, array2
    add a3, a3, t5
    lbu a6, 0(a3)
done:
    ret
