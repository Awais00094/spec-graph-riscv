# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t2, array1_size
    lw t2, 0(t2)
    bgeu t0, t2, done
    la t1, array1
    add t1, t1, t0
    lbu t3, 0(t1)
    addi t3, t3, 1
    la a6, counter
    lbu t6, 0(a6)
    add t6, t6, t3
    sb t6, 0(a6)
done:
    ret
