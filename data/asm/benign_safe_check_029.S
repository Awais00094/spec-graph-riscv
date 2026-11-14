# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t4, array1_size
    lw t4, 0(t4)
    bgeu a3, t4, done
    la a2, array1
    add a2, a2, a3
    lbu t1, 0(a2)
    addi t1, t1, 1
    la t2, counter
    lbu t5, 0(t2)
    add t5, t5, t1
    sb t5, 0(t2)
done:
    ret
