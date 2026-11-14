# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a2, src
    la a6, dst
    li t1, 32
loop:
    lbu t2, 0(a2)
    sb t2, 0(a6)
    addi a2, a2, 1
    addi a6, a6, 1
    addi t1, t1, -1
    bnez t1, loop
    ret
