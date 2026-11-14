# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a6, src
    la a3, dst
    li t0, 128
loop:
    lbu a2, 0(a6)
    sb a2, 0(a3)
    addi a6, a6, 1
    addi a3, a3, 1
    addi t0, t0, -1
    bnez t0, loop
    ret
