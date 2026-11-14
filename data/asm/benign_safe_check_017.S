# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t5, array1_size
    lw t5, 0(t5)
    bgeu t0, t5, done
    la a7, array1
    add a7, a7, t0
    lbu t3, 0(a7)
    addi t3, t3, 1
    la t4, counter
    lbu t6, 0(t4)
    add t6, t6, t3
    sb t6, 0(t4)
done:
    ret
