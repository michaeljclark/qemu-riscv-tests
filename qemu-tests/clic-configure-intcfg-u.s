# See LICENSE for license details.

.include "qemu-tests/common-header.s"

.section .text
.globl reset_vector
reset_vector:

# It's required to set nmbits=2 if we wish to configure S-mode interrupts

# load the cliccfg address and configure mode+level+priority
        li      a0, (CLIC_BASE + CLIC_MMODE_OFFSET + CLIC_CFG_OFFSET)

# set nmbits=2, nlbits=4
        li      t0, 0b101000
        sb      t0, (a0)
        lbu     t1, (a0)
        bne     t0, t1, fail

# load the clicintcfg address and configure mode+level+priority
        li      a0, (CLIC_BASE + CLIC_SMODE_OFFSET + CLIC_INTCFG_OFFSET)

# set MTI mode+level+priority and check result
        li      t0, 0
        sb      t0, (MTI)(a0)
        lbu     t1, (MTI)(a0)
        bne     t0, t1, fail

# set MTI mode+level+priority and check result
        li      t0, 0b01111111
        sb      t0, (MTI)(a0)
        lbu     t1, (MTI)(a0)
        bne     t0, t1, fail

# fall through to pass
        j       pass

.include "qemu-tests/common-footer.s"
