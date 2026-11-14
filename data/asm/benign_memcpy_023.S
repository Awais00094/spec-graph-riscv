# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t6, src
    la a6, dst
    li t4, 128
loop:
    lbu t1, 0(t6)
    sb t1, 0(a6)
    addi t6, t6, 1
    addi a6, a6, 1
    addi t4, t4, -1
    bnez t4, loop
    ret
