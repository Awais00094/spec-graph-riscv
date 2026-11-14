# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t3, src
    la a7, dst
    li a5, 128
loop:
    lbu t4, 0(t3)
    sb t4, 0(a7)
    addi t3, t3, 1
    addi a7, a7, 1
    addi a5, a5, -1
    bnez a5, loop
    ret
