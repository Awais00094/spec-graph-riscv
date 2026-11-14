# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a7, 0
    li t3, 0
    li t0, 64
    la a5, buf
loop:
    lw a3, 0(a5)
    add a7, a7, a3
    addi a5, a5, 4
    addi t3, t3, 1
    blt t3, t0, loop
    ret
