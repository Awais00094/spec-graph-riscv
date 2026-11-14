# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a7, array1_size
    lw a7, 0(a7)
    bgeu a2, a7, done
    la t2, array1
    add t2, t2, a2
    lbu a5, 0(t2)
    addi a5, a5, 1
    la t1, counter
    lbu t0, 0(t1)
    add t0, t0, a5
    sb t0, 0(t1)
done:
    ret
