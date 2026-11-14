# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t6, src
    la t3, dst
    li t2, 32
loop:
    lbu t4, 0(t6)
    sb t4, 0(t3)
    addi t6, t6, 1
    addi t3, t3, 1
    addi t2, t2, -1
    bnez t2, loop
    ret
