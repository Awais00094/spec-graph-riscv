# template=benign_loop family=benign label=0 wrapped=0
sum:
    li t1, 0
    li a7, 0
    li t4, 256
    la t0, buf
loop:
    lw a2, 0(t0)
    add t1, t1, a2
    addi t0, t0, 4
    addi a7, a7, 1
    blt a7, t4, loop
    ret
