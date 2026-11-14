# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a5, array1_size
    lw a5, 0(a5)
    bgeu a4, a5, done
    la t4, array1
    add t4, t4, a4
    lbu t2, 0(t4)
    addi t2, t2, 1
    la a7, counter
    lbu t5, 0(a7)
    add t5, t5, t2
    sb t5, 0(a7)
done:
    ret
