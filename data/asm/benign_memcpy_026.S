# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a5, src
    la a7, dst
    li a4, 64
loop:
    lbu t6, 0(a5)
    sb t6, 0(a7)
    addi a5, a5, 1
    addi a7, a7, 1
    addi a4, a4, -1
    bnez a4, loop
    ret
