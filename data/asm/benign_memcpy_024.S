# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t2, src
    la t6, dst
    li t5, 64
loop:
    lbu a6, 0(t2)
    sb a6, 0(t6)
    addi t2, t2, 1
    addi t6, t6, 1
    addi t5, t5, -1
    bnez t5, loop
    ret
