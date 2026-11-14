# template=spectre_v1 family=v1 label=1 wrapped=0
gadget:
    la a2, array1_size
    lw a2, 0(a2)

    bgeu a3, a2, done
    la t1, array1
    add t1, t1, a3
    lbu t5, 0(t1)
    slli t5, t5, 10
    la t4, array2
    add t4, t4, t5
    lbu a7, 0(t4)
done:
    ret
