# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t6, array1_size
    lw t6, 0(t6)
    bgeu t0, t6, done
    la t3, array1
    add t3, t3, t0
    lbu a4, 0(t3)
    addi a4, a4, 1
    la a7, counter
    lbu a2, 0(a7)
    add a2, a2, a4
    sb a2, 0(a7)
done:
    ret
