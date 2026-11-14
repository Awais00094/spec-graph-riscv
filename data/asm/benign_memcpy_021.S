# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t1, src
    la t0, dst
    li t6, 64
loop:
    lbu t5, 0(t1)
    sb t5, 0(t0)
    addi t1, t1, 1
    addi t0, t0, 1
    addi t6, t6, -1
    bnez t6, loop
    ret
