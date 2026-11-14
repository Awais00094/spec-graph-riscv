# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a2, src
    la a7, dst
    li t5, 64
loop:
    lbu a4, 0(a2)
    sb a4, 0(a7)
    addi a2, a2, 1
    addi a7, a7, 1
    addi t5, t5, -1
    bnez t5, loop
    ret
