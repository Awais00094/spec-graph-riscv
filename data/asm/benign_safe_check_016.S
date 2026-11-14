# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a7, array1_size
    lw a7, 0(a7)
    bgeu t6, a7, done
    la a3, array1
    add a3, a3, t6
    lbu a6, 0(a3)
    addi a6, a6, 1
    la t2, counter
    lbu a5, 0(t2)
    add a5, a5, a6
    sb a5, 0(t2)
done:
    ret
