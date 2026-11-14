# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a5, 0
    li t5, 0
    li a2, 64
    la t1, buf
loop:
    lw t4, 0(t1)
    add a5, a5, t4
    addi t1, t1, 4
    addi t5, t5, 1
    blt t5, a2, loop
    ret
