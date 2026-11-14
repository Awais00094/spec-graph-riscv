# template=wrapped_v1 family=v1 label=0 wrapped=1
gadget:
    la a2, array1_size
    lw a2, 0(a2)

    sltu t0, a3, a2
    neg t0, t0
    and a3, a3, t0
    fence rw, rw
    bgeu a3, a2, done
    la t1, array1
    add t1, t1, a3
    lbu t5, 0(t1)
    slli t5, t5, 10
    la t4, array2
    add t4, t4, t5
    lbu a7, 0(t4)
done:
    ret
