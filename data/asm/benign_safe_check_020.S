# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t6, array1_size
    lw t6, 0(t6)
    bgeu t2, t6, done
    la t0, array1
    add t0, t0, t2
    lbu a4, 0(t0)
    addi a4, a4, 1
    la t5, counter
    lbu a7, 0(t5)
    add a7, a7, a4
    sb a7, 0(t5)
done:
    ret
