# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t2, 0
    li t1, 0
    li t0, 256
    la a4, buf
loop:
    lw t6, 0(a4)
    add t2, t2, t6
    addi a4, a4, 4
    addi t1, t1, 1
    blt t1, t0, loop
    ret
