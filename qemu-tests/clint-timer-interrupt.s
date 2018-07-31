.include "qemu-tests/common-header.s"

.section .text
# See LICENSE for license details.

.globl reset_vector
reset_vector:

# setup mtvec
1:      auipc   t0, %pcrel_hi(mtvec)        # load mtvec(hi)
        addi    t0, t0, %pcrel_lo(1b)       # load mtvec(lo)
        csrrw   zero, mtvec, t0

# set mstatus.MIE=1 (enable M mode interrupt)
        li      t0, MSTATUS_MIE
        csrrs   zero, mstatus, t0

# set mie.MTIE=1 (enable M mode timer interrupts)
        li      t0, MIE_MTIE
        csrrs   zero, mie, t0

# load clint time and timecmp addresses
        li      a0, CLINT_BASE + CLINT_TIME
        li      a1, CLINT_BASE + CLINT_TIMECMP

# read time and set timecmp to time + 100000
        lw      a2, 0(a0)
        li      t0, 100000
        add     a2, a2, t0
        sw      a2, 0(a1)

# poll the timer until time + 200000
        add     a2, a2, t0
1:      lw      a3, 0(a0)
        ble     a3, a2, 1b
        j       fail

# interrupt vector
.align 3
mtvec:
        csrrw   s0, mcause, zero
        bgez    s0, fail
        slli    s0, s0, 1
        srli    s0, s0, 1
        li      s1, MTI
        bne     s0, s1, fail
        j       pass

.include "qemu-tests/common-footer.s"
