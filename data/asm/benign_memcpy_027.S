# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t4, src
    la t2, dst
    li a4, 128
loop:
    lbu a3, 0(t4)
    sb a3, 0(t2)
    addi t4, t4, 1
    addi t2, t2, 1
    addi a4, a4, -1
    bnez a4, loop
    ret
