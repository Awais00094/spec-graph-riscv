# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a5, 0
    li a4, 0
    li t1, 256
    la a7, buf
loop:
    lw a6, 0(a7)
    add a5, a5, a6
    addi a7, a7, 4
    addi a4, a4, 1
    blt a4, t1, loop
    ret
