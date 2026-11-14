# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t3, src
    la t6, dst
    li a3, 64
loop:
    lbu a4, 0(t3)
    sb a4, 0(t6)
    addi t3, t3, 1
    addi t6, t6, 1
    addi a3, a3, -1
    bnez a3, loop
    ret
