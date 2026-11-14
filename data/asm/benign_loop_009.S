# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t5, 0
    li a3, 0
    li a5, 64
    la t6, buf
loop:
    lw t2, 0(t6)
    add t5, t5, t2
    addi t6, t6, 4
    addi a3, a3, 1
    blt a3, a5, loop
    ret
