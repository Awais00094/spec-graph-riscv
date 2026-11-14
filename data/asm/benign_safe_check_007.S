# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a6, array1_size
    lw a6, 0(a6)
    bgeu t1, a6, done
    la a7, array1
    add a7, a7, t1
    lbu t2, 0(a7)
    addi t2, t2, 1
    la a5, counter
    lbu t6, 0(a5)
    add t6, t6, t2
    sb t6, 0(a5)
done:
    ret
