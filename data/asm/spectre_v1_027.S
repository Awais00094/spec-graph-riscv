# template=spectre_v1 family=v1 label=1 wrapped=0
gadget:
    la a2, array1_size
    lw a2, 0(a2)
    slli a6, a6, 1
    ori a6, a6, 3
    bgeu t5, a2, done
    la a4, array1
    add a4, a4, t5
    lbu t2, 0(a4)
    slli t2, t2, 10
    la t0, array2
    add t0, t0, t2
    lbu a6, 0(t0)
done:
    ret
