# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t4, array1_size
    lw t4, 0(t4)
    bgeu a6, t4, done
    la t1, array1
    add t1, t1, a6
    lbu a7, 0(t1)
    addi a7, a7, 1
    la t0, counter
    lbu a2, 0(t0)
    add a2, a2, a7
    sb a2, 0(t0)
done:
    ret
