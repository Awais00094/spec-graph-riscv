# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a4, src
    la t0, dst
    li t3, 32
loop:
    lbu a3, 0(a4)
    sb a3, 0(t0)
    addi a4, a4, 1
    addi t0, t0, 1
    addi t3, t3, -1
    bnez t3, loop
    ret
