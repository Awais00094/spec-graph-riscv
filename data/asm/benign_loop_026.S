# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a6, 0
    li a2, 0
    li a3, 64
    la a5, buf
loop:
    lw t1, 0(a5)
    add a6, a6, t1
    addi a5, a5, 4
    addi a2, a2, 1
    blt a2, a3, loop
    ret
