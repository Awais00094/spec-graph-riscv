# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a4, array1_size
    lw a4, 0(a4)
    bgeu t2, a4, done
    la t1, array1
    add t1, t1, t2
    lbu a5, 0(t1)
    addi a5, a5, 1
    la t5, counter
    lbu a7, 0(t5)
    add a7, a7, a5
    sb a7, 0(t5)
done:
    ret
