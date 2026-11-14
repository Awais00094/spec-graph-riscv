# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a6, array1_size
    lw a6, 0(a6)
    bgeu t6, a6, done
    la a5, array1
    add a5, a5, t6
    lbu t3, 0(a5)
    addi t3, t3, 1
    la t4, counter
    lbu a4, 0(t4)
    add a4, a4, t3
    sb a4, 0(t4)
done:
    ret
