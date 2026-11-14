# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a4, array1_size
    lw a4, 0(a4)
    bgeu t6, a4, done
    la a3, array1
    add a3, a3, t6
    lbu t0, 0(a3)
    addi t0, t0, 1
    la a7, counter
    lbu t3, 0(a7)
    add t3, t3, t0
    sb t3, 0(a7)
done:
    ret
