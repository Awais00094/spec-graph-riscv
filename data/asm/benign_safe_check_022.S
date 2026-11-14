# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a5, array1_size
    lw a5, 0(a5)
    bgeu a7, a5, done
    la a3, array1
    add a3, a3, a7
    lbu t3, 0(a3)
    addi t3, t3, 1
    la a6, counter
    lbu t1, 0(a6)
    add t1, t1, t3
    sb t1, 0(a6)
done:
    ret
