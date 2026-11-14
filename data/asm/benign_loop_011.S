# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a2, 0
    li t5, 0
    li a7, 128
    la t0, buf
loop:
    lw a3, 0(t0)
    add a2, a2, a3
    addi t0, t0, 4
    addi t5, t5, 1
    blt t5, a7, loop
    ret
