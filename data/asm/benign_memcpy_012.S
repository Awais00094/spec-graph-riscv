# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a4, src
    la t1, dst
    li t3, 64
loop:
    lbu a2, 0(a4)
    sb a2, 0(t1)
    addi a4, a4, 1
    addi t1, t1, 1
    addi t3, t3, -1
    bnez t3, loop
    ret
