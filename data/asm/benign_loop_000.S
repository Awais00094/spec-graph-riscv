# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t2, 0
    li a6, 0
    li a5, 256
    la t6, buf
loop:
    lw t4, 0(t6)
    add t2, t2, t4
    addi t6, t6, 4
    addi a6, a6, 1
    blt a6, a5, loop
    ret
