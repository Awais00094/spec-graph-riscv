# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la t4, src
    la a5, dst
    li a3, 64
loop:
    lbu t5, 0(t4)
    sb t5, 0(a5)
    addi t4, t4, 1
    addi a5, a5, 1
    addi a3, a3, -1
    bnez a3, loop
    ret
