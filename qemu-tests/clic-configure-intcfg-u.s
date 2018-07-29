.include "qemu-tests/common-header.s"

.section .text
.globl reset_vector
reset_vector:

# load the clicintcfg address and configure mode+level+priority
        li      a0, (CLIC_BASE + CLIC_SMODE_OFFSET + CLIC_INTCFG_OFFSET)
        li      t0, 0
        sb      t0, (MTI)(a0)
# read back and check result
        lb      t1, (MTI)(a0)
        bne     t0, t1, fail
        j       pass

.include "qemu-tests/common-footer.s"
