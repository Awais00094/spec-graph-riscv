# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a6, src
    la t3, dst
    li a7, 128
loop:
    lbu t0, 0(a6)
    sb t0, 0(t3)
    addi a6, a6, 1
    addi t3, t3, 1
    addi a7, a7, -1
    bnez a7, loop
    ret
