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
        li      a0, (CLIC_BASE + CLIC_SMODE_OFFSET + CLIC_CFG_OFFSET)
        li      t0, 0
        sb      t0, (a0)
# read back and check result
        lb      t1, (a0)
        bne     t0, t1, fail
        j       pass

.include "qemu-tests/common-footer.s"
