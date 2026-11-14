# template=benign_loop family=benign label=0 wrapped=0
sum:
    li a2, 0
    li a4, 0
    li t4, 128
    la t6, buf
loop:
    lw t2, 0(t6)
    add a2, a2, t2
    addi t6, t6, 4
    addi a4, a4, 1
    blt a4, t4, loop
    ret
