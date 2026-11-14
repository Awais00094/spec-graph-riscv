# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t5, array1_size
    lw t5, 0(t5)
    bgeu t4, t5, done
    la a5, array1
    add a5, a5, t4
    lbu t2, 0(a5)
    addi t2, t2, 1
    la t3, counter
    lbu a3, 0(t3)
    add a3, a3, t2
    sb a3, 0(t3)
done:
    ret
