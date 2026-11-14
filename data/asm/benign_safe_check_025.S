# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a4, array1_size
    lw a4, 0(a4)
    bgeu t6, a4, done
    la t0, array1
    add t0, t0, t6
    lbu a2, 0(t0)
    addi a2, a2, 1
    la a7, counter
    lbu a6, 0(a7)
    add a6, a6, a2
    sb a6, 0(a7)
done:
    ret
