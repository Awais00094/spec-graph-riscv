# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t6, src
    la t3, dst
    li t0, 32
loop:
    lbu t1, 0(t6)
    sb t1, 0(t3)
    addi t6, t6, 1
    addi t3, t3, 1
    addi t0, t0, -1
    bnez t0, loop
    ret
