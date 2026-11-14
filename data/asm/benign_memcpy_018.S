# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a7, src
    la t2, dst
    li t3, 128
loop:
    lbu t6, 0(a7)
    sb t6, 0(t2)
    addi a7, a7, 1
    addi t2, t2, 1
    addi t3, t3, -1
    bnez t3, loop
    ret
