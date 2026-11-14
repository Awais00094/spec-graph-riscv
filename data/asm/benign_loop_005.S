# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a6, 0
    li t2, 0
    li t4, 256
    la t0, buf
loop:
    lw a2, 0(t0)
    add a6, a6, a2
    addi t0, t0, 4
    addi t2, t2, 1
    blt t2, t4, loop
    ret
