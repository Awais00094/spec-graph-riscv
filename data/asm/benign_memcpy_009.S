# template=benign_memcpy family=benign label=0 wrapped=0
copy:
    la a2, src
    la t3, dst
    li a3, 32
loop:
    lbu t0, 0(a2)
    sb t0, 0(t3)
    addi a2, a2, 1
    addi t3, t3, 1
    addi a3, a3, -1
    bnez a3, loop
    ret
