# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la t2, array1_size
    lw t2, 0(t2)
    slli a3, a3, 1
    sltu a4, a5, t2
    neg a4, a4
    and a5, a5, a4
    fence rw, rw
    bgeu a5, t2, done
    la t6, array1
    add t6, t6, a5
    lbu t3, 0(t6)
    slli t3, t3, 10
    la a2, array2
    add a2, a2, t3
    lbu a3, 0(a2)
done:
    ret
