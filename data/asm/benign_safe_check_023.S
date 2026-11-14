# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a4, array1_size
    lw a4, 0(a4)
    bgeu t6, a4, done
    la t5, array1
    add t5, t5, t6
    lbu t4, 0(t5)
    addi t4, t4, 1
    la t3, counter
    lbu t1, 0(t3)
    add t1, t1, t4
    sb t1, 0(t3)
done:
    ret
