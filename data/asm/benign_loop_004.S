# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t0, 0
    li t4, 0
    li t1, 256
    la a6, buf
loop:
    lw t3, 0(a6)
    add t0, t0, t3
    addi a6, a6, 4
    addi t4, t4, 1
    blt t4, t1, loop
    ret
