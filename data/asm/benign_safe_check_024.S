# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la t4, array1_size
    lw t4, 0(t4)
    bgeu t0, t4, done
    la t5, array1
    add t5, t5, t0
    lbu t3, 0(t5)
    addi t3, t3, 1
    la a2, counter
    lbu a4, 0(a2)
    add a4, a4, t3
    sb a4, 0(a2)
done:
    ret
