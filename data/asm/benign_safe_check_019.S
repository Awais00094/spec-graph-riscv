# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t3, array1_size
    lw t3, 0(t3)
    bgeu a4, t3, done
    la t6, array1
    add t6, t6, a4
    lbu t4, 0(t6)
    addi t4, t4, 1
    la a5, counter
    lbu a3, 0(a5)
    add a3, a3, t4
    sb a3, 0(a5)
done:
    ret
