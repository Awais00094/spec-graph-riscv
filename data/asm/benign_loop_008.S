# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a5, 0
    li t6, 0
    li a7, 256
    la t5, buf
loop:
    lw a3, 0(t5)
    add a5, a5, a3
    addi t5, t5, 4
    addi t6, t6, 1
    blt t6, a7, loop
    ret
