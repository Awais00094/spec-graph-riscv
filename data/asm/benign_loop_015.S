# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a5, 0
    li a3, 0
    li a4, 128
    la t6, buf
loop:
    lw a6, 0(t6)
    add a5, a5, a6
    addi t6, t6, 4
    addi a3, a3, 1
    blt a3, a4, loop
    ret
