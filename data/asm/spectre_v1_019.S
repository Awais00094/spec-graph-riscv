# template=spectre_v1 family=v1 label=1 wrapped=0
gadget:
    la t3, array1_size
    lw t3, 0(t3)

    bgeu a2, t3, done
    la a4, array1
    add a4, a4, a2
    lbu t2, 0(a4)
    slli t2, t2, 10
    la t6, array2
    add t6, t6, t2
    lbu a3, 0(t6)
done:
    ret
