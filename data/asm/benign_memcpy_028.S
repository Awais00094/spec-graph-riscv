# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t0, src
    la t3, dst
    li t5, 64
loop:
    lbu a2, 0(t0)
    sb a2, 0(t3)
    addi t0, t0, 1
    addi t3, t3, 1
    addi t5, t5, -1
    bnez t5, loop
    ret
