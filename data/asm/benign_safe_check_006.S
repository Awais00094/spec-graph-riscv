# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a4, array1_size
    lw a4, 0(a4)
    bgeu a6, a4, done
    la t3, array1
    add t3, t3, a6
    lbu a7, 0(t3)
    addi a7, a7, 1
    la t5, counter
    lbu t4, 0(t5)
    add t4, t4, a7
    sb t4, 0(t5)
done:
    ret
