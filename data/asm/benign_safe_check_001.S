# template=benign_safe_check family=benign label=0 wrapped=0
safe:
    la a4, array1_size
    lw a4, 0(a4)
    bgeu a3, a4, done
    la t6, array1
    add t6, t6, a3
    lbu t4, 0(t6)
    addi t4, t4, 1
    la t0, counter
    lbu a6, 0(t0)
    add a6, a6, t4
    sb a6, 0(t0)
done:
    ret
