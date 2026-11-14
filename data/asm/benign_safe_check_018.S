# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t4, array1_size
    lw t4, 0(t4)
    bgeu t2, t4, done
    la t0, array1
    add t0, t0, t2
    lbu a2, 0(t0)
    addi a2, a2, 1
    la t1, counter
    lbu a3, 0(t1)
    add a3, a3, a2
    sb a3, 0(t1)
done:
    ret
