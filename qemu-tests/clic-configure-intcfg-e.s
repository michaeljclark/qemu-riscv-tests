# See LICENSE for license details.

.include "qemu-tests/common-header.s"

.section .text
.globl reset_vector
reset_vector:

# load the clicintcfg address and configure mode+level+priority
        li      a0, (CLIC_BASE + CLIC_MMODE_OFFSET + CLIC_INTCFG_OFFSET)

# set MTI mode+level+priority and check result
        li      t0, 0
        sb      t0, (MTI)(a0)
        lbu     t1, (MTI)(a0)
        bne     t0, t1, fail

# set MTI mode+level+priority and check result
        li      t0, 0b11110000
        sb      t0, (MTI)(a0)
        lbu     t1, (MTI)(a0)
        bne     t0, t1, fail

# set MTI mode+level+priority and check result
        li      t0, 0b11111111
        sb      t0, (MTI)(a0)
        li      t0, 0b11110000 # truncated to INT_BITS
        lbu     t1, (MTI)(a0)
        bne     t0, t1, fail

# fall through to pass
        j       pass

.include "qemu-tests/common-footer.s"
