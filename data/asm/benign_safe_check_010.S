# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a4, array1_size
    lw a4, 0(a4)
    bgeu a2, a4, done
    la t0, array1
    add t0, t0, a2
    lbu t1, 0(t0)
    addi t1, t1, 1
    la t2, counter
    lbu t4, 0(t2)
    add t4, t4, t1
    sb t4, 0(t2)
done:
    ret
