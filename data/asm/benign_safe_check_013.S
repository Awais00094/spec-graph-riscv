# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t0, array1_size
    lw t0, 0(t0)
    bgeu t1, t0, done
    la t5, array1
    add t5, t5, t1
    lbu a2, 0(t5)
    addi a2, a2, 1
    la a7, counter
    lbu t3, 0(a7)
    add t3, t3, a2
    sb t3, 0(a7)
done:
    ret
