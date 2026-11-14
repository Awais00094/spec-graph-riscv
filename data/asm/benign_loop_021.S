# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t6, 0
    li a5, 0
    li a7, 256
    la t1, buf
loop:
    lw t2, 0(t1)
    add t6, t6, t2
    addi t1, t1, 4
    addi a5, a5, 1
    blt a5, a7, loop
    ret
