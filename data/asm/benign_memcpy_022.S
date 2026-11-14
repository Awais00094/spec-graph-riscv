# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a7, src
    la t4, dst
    li a5, 128
loop:
    lbu t6, 0(a7)
    sb t6, 0(t4)
    addi a7, a7, 1
    addi t4, t4, 1
    addi a5, a5, -1
    bnez a5, loop
    ret
