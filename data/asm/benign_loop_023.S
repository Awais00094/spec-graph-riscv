# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a7, 0
    li t0, 0
    li a2, 256
    la t2, buf
loop:
    lw a4, 0(t2)
    add a7, a7, a4
    addi t2, t2, 4
    addi t0, t0, 1
    blt t0, a2, loop
    ret
