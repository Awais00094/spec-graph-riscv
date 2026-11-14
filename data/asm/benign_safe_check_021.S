# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a7, array1_size
    lw a7, 0(a7)
    bgeu t6, a7, done
    la a3, array1
    add a3, a3, t6
    lbu t0, 0(a3)
    addi t0, t0, 1
    la t1, counter
    lbu a4, 0(t1)
    add a4, a4, t0
    sb a4, 0(t1)
done:
    ret
