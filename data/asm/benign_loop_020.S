# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t6, 0
    li t5, 0
    li a3, 256
    la a6, buf
loop:
    lw t3, 0(a6)
    add t6, t6, t3
    addi a6, a6, 4
    addi t5, t5, 1
    blt t5, a3, loop
    ret
