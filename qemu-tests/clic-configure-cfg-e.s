.include "qemu-tests/common-header.s"

.section .text
.globl reset_vector
reset_vector:

# cliccfg
#                                     E U
# 5:4   nmbits[1:0]   MAX_MODE_BITS   0 2
# 3:1   nlbits[2:0]   MAX_LEVEL_BITS  4 4
# 0     nvbits        MAX_VEC_BITS    1 1
#                     MAX_INT_BITS    4 8

# load the cliccfg address and configure mode+level+priority
        li      a0, (CLIC_BASE + CLIC_MMODE_OFFSET + CLIC_CFG_OFFSET)

# try nmbits=0, nlbits=0, nvbits=0
        li      t0, 0
        sb      t0, (a0)
        lbu     t1, (a0)
        bne     t0, t1, fail

# try nmbits=0, nlbits=4, nvbits=0
        li      t0, 0b1000
        sb      t0, (a0)
        lbu     t1, (a0)
        bne     t0, t1, fail

# try nmbits=0, nlbits=7, nvbits=0
        li      t0, 0b1110
        sb      t0, (a0)
        li      t0, 0b1000 #  resuting nlbits=4
        lbu     t1, (a0)
        bne     t0, t1, fail

# try nmbits=0, nlbits=4, nvbits=0
        li      t0, 0b1001
        sb      t0, (a0)
        lbu     t1, (a0)
        bne     t0, t1, fail

# try nmbits=2, nlbits=4, nvbits=o
        li      t0, 0b101000
        sb      t0, (a0)
        li      t0, 0b1000 #  resuting nmbits=0
        lbu     t1, (a0)
        bne     t0, t1, fail

# fall through to pass
        j       pass

.include "qemu-tests/common-footer.s"
