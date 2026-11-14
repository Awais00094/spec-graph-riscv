# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t2, src
    la t4, dst
    li t6, 128
loop:
    lbu t0, 0(t2)
    sb t0, 0(t4)
    addi t2, t2, 1
    addi t4, t4, 1
    addi t6, t6, -1
    bnez t6, loop
    ret
