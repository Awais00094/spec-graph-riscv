# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t5, src
    la t2, dst
    li t4, 64
loop:
    lbu a3, 0(t5)
    sb a3, 0(t2)
    addi t5, t5, 1
    addi t2, t2, 1
    addi t4, t4, -1
    bnez t4, loop
    ret
