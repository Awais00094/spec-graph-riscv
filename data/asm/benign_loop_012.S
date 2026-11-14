# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a2, 0
    li t0, 0
    li t3, 64
    la a6, buf
loop:
    lw t4, 0(a6)
    add a2, a2, t4
    addi a6, a6, 4
    addi t0, t0, 1
    blt t0, t3, loop
    ret
