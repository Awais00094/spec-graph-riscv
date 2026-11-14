# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la a2, array1_size
    lw a2, 0(a2)

    sltu a7, t3, a2
    neg a7, a7
    and t3, t3, a7
    fence rw, rw
    bgeu t3, a2, done
    la a6, array1
    add a6, a6, t3
    lbu a5, 0(a6)
    slli a5, a5, 10
    la t5, array2
    add t5, t5, a5
    lbu t0, 0(t5)
done:
    ret
