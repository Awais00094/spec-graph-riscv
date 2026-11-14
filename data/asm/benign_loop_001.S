# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t5, 0
    li a4, 0
    li t3, 128
    la t1, buf
loop:
    lw a3, 0(t1)
    add t5, t5, a3
    addi t1, t1, 4
    addi a4, a4, 1
    blt a4, t3, loop
    ret
