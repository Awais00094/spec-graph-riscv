# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t3, 0
    li t6, 0
    li a3, 64
    la t0, buf
loop:
    lw a4, 0(t0)
    add t3, t3, a4
    addi t0, t0, 4
    addi t6, t6, 1
    blt t6, a3, loop
    ret
