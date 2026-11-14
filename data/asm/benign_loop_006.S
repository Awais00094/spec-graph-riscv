# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a6, 0
    li t1, 0
    li a4, 256
    la a5, buf
loop:
    lw t0, 0(a5)
    add a6, a6, t0
    addi a5, a5, 4
    addi t1, t1, 1
    blt t1, a4, loop
    ret
