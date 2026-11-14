# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a5, 0
    li a2, 0
    li t5, 128
    la a3, buf
loop:
    lw a7, 0(a3)
    add a5, a5, a7
    addi a3, a3, 4
    addi a2, a2, 1
    blt a2, t5, loop
    ret
