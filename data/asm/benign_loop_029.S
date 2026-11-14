# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t1, 0
    li a7, 0
    li t0, 128
    la a6, buf
loop:
    lw t5, 0(a6)
    add t1, t1, t5
    addi a6, a6, 4
    addi a7, a7, 1
    blt a7, t0, loop
    ret
