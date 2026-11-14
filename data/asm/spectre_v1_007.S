# template=spectre_v1 family=v1 label=1 wrapped=0
gadget:
    la a2, array1_size
    lw a2, 0(a2)

    bgeu t0, a2, done
    la t4, array1
    add t4, t4, t0
    lbu a4, 0(t4)
    slli a4, a4, 10
    la t6, array2
    add t6, t6, a4
    lbu t2, 0(t6)
done:
    ret
