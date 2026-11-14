# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t3, 0
    li t0, 0
    li a3, 256
    la a4, buf
loop:
    lw t6, 0(a4)
    add t3, t3, t6
    addi a4, a4, 4
    addi t0, t0, 1
    blt t0, a3, loop
    ret
