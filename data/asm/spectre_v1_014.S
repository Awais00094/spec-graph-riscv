# template=spectre_v1 family=v1 label=1 wrapped=0
gadget:
    la t0, array1_size
    lw t0, 0(t0)
    addi t2, t2, 1
    bgeu a3, t0, done
    la a6, array1
    add a6, a6, a3
    lbu a2, 0(a6)
    slli a2, a2, 9
    la a7, array2
    add a7, a7, a2
    lbu t2, 0(a7)
done:
    ret
