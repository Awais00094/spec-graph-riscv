# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a3, array1_size
    lw a3, 0(a3)
    bgeu t3, a3, done
    la t4, array1
    add t4, t4, t3
    lbu a6, 0(t4)
    addi a6, a6, 1
    la t6, counter
    lbu t5, 0(t6)
    add t5, t5, a6
    sb t5, 0(t6)
done:
    ret
