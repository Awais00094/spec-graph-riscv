# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a2, array1_size
    lw a2, 0(a2)
    bgeu t6, a2, done
    la t0, array1
    add t0, t0, t6
    lbu t2, 0(t0)
    addi t2, t2, 1
    la t4, counter
    lbu t3, 0(t4)
    add t3, t3, t2
    sb t3, 0(t4)
done:
    ret
