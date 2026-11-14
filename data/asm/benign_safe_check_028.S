# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t6, array1_size
    lw t6, 0(t6)
    bgeu a3, t6, done
    la a4, array1
    add a4, a4, a3
    lbu a6, 0(a4)
    addi a6, a6, 1
    la a5, counter
    lbu t0, 0(a5)
    add t0, t0, a6
    sb t0, 0(a5)
done:
    ret
