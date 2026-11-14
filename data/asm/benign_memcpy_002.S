# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a7, src
    la a3, dst
    li t0, 64
loop:
    lbu a2, 0(a7)
    sb a2, 0(a3)
    addi a7, a7, 1
    addi a3, a3, 1
    addi t0, t0, -1
    bnez t0, loop
    ret
