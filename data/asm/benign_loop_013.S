# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a4, 0
    li t4, 0
    li t0, 256
    la a7, buf
loop:
    lw t3, 0(a7)
    add a4, a4, t3
    addi a7, a7, 4
    addi t4, t4, 1
    blt t4, t0, loop
    ret
