# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t2, 0
    li t1, 0
    li t6, 64
    la a4, buf
loop:
    lw a7, 0(a4)
    add t2, t2, a7
    addi a4, a4, 4
    addi t1, t1, 1
    blt t1, t6, loop
    ret
