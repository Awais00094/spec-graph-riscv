# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t4, 0
    li a5, 0
    li t0, 128
    la a4, buf
loop:
    lw t5, 0(a4)
    add t4, t4, t5
    addi a4, a4, 4
    addi a5, a5, 1
    blt a5, t0, loop
    ret
