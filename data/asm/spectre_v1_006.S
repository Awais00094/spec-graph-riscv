# template=spectre_v1 family=v1 label=1 wrapped=0
gadget:
    la t0, array1_size
    lw t0, 0(t0)
    addi t5, t5, 1
    bgeu t4, t0, done
    la a3, array1
    add a3, a3, t4
    lbu t3, 0(a3)
    slli t3, t3, 9
    la t1, array2
    add t1, t1, t3
    lbu t5, 0(t1)
done:
    ret
