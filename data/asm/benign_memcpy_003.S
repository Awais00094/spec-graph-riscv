# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t1, src
    la t2, dst
    li t0, 128
loop:
    lbu t6, 0(t1)
    sb t6, 0(t2)
    addi t1, t1, 1
    addi t2, t2, 1
    addi t0, t0, -1
    bnez t0, loop
    ret
