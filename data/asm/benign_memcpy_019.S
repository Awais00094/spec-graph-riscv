# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a6, src
    la t3, dst
    li a2, 32
loop:
    lbu a5, 0(a6)
    sb a5, 0(t3)
    addi a6, a6, 1
    addi t3, t3, 1
    addi a2, a2, -1
    bnez a2, loop
    ret
