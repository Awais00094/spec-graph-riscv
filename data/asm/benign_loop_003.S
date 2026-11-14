# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t4, 0
    li t5, 0
    li t0, 256
    la a6, buf
loop:
    lw a2, 0(a6)
    add t4, t4, a2
    addi a6, a6, 4
    addi t5, t5, 1
    blt t5, t0, loop
    ret
