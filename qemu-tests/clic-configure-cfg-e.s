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

# load the clicintcfg address and configure mode+level+priority
        li      a0, (CLIC_BASE + CLIC_MMODE_OFFSET + CLIC_CFG_OFFSET)
        li      t0, 0
        sb      t0, (a0)
# read back and check result
        lb      t1, (a0)
        bne     t0, t1, fail

# try level bits=4
        li      t0, 0b1000
        sb      t0, (a0)
        lb      t1, (a0)
        bne     t0, t1, fail

# try level bits=4, vec bits=1
        li      t0, 0b1001
        sb      t0, (a0)
        lb      t1, (a0)
        bne     t0, t1, fail

# try mode bits=2, level bits=4
        li      t0, 0b101000
        sb      t0, (a0)
        li      t0, 0b1000 #  resuting mode bits=0
        lb      t1, (a0)
        bne     t0, t1, fail

# fall through to pass
        j       pass

.include "qemu-tests/common-footer.s"
