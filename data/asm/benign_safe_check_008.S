# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a2, array1_size
    lw a2, 0(a2)
    bgeu t0, a2, done
    la t6, array1
    add t6, t6, t0
    lbu t1, 0(t6)
    addi t1, t1, 1
    la t4, counter
    lbu a6, 0(t4)
    add a6, a6, t1
    sb a6, 0(t4)
done:
    ret
