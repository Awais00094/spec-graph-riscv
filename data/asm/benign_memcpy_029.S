# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a3, src
    la t1, dst
    li t2, 32
loop:
    lbu a6, 0(a3)
    sb a6, 0(t1)
    addi a3, a3, 1
    addi t1, t1, 1
    addi t2, t2, -1
    bnez t2, loop
    ret
