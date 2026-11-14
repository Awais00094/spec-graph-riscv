# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t0, 0
    li t2, 0
    li a5, 256
    la a2, buf
loop:
    lw t3, 0(a2)
    add t0, t0, t3
    addi a2, a2, 4
    addi t2, t2, 1
    blt t2, a5, loop
    ret
