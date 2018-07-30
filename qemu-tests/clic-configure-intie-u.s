.include "qemu-tests/common-header.s"

.section .text
.globl reset_vector
reset_vector:

# load the clicintcfg address and configure mode+level+priority
        li      a0, (CLIC_BASE + CLIC_SMODE_OFFSET + CLIC_INTIE_OFFSET)

# enable MTI and check result
        li      t0, 1
        sb      t0, (MTI)(a0)
        lbu     t1, (MTI)(a0)
        bne     t0, t1, fail

# disable MTI and check result
        li      t0, 0
        sb      t0, (MTI)(a0)
        lbu     t1, (MTI)(a0)
        bne     t0, t1, fail

# enable MTI with non-zero value and check result
        li      t0, 2
        sb      t0, (MTI)(a0)
        li      t0, 1          # resulting value is 1
        lbu     t1, (MTI)(a0)
        bne     t0, t1, fail

# fall through to pass
        j       pass

.include "qemu-tests/common-footer.s"
