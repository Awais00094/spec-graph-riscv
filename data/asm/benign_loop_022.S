# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a2, 0
    li a4, 0
    li a7, 64
    la a6, buf
loop:
    lw a5, 0(a6)
    add a2, a2, a5
    addi a6, a6, 4
    addi a4, a4, 1
    blt a4, a7, loop
    ret
