# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t3, array1_size
    lw t3, 0(t3)
    bgeu a2, t3, done
    la a5, array1
    add a5, a5, a2
    lbu a3, 0(a5)
    addi a3, a3, 1
    la t4, counter
    lbu a7, 0(t4)
    add a7, a7, a3
    sb a7, 0(t4)
done:
    ret
