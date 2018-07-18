.include "qemu-tests/common-header.s"

.section .text
.globl reset_vector
reset_vector:

# load the clicintie address and enable MTI
        li      a0, (CLIC_BASE + CLIC_MMODE_OFFSET + CLIC_INTIE_OFFSET)
        li      t0, 1
        sb      t0, (MTI)(a0)
# read back and check result
        lb      t1, (MTI)(a0)
        bne     t0, t1, fail
# disable MTI
        li      t0, 0
        sb      t0, (MTI)(a0)
# read back and check result
        lb      t1, (MTI)(a0)
        bne     t0, t1, fail
        j       pass

.include "qemu-tests/common-footer.s"