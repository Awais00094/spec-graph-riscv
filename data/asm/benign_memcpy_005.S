# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t2, src
    la a2, dst
    li a4, 128
loop:
    lbu a3, 0(t2)
    sb a3, 0(a2)
    addi t2, t2, 1
    addi a2, a2, 1
    addi a4, a4, -1
    bnez a4, loop
    ret
