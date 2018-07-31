.include "qemu-tests/common-header.s"

.section .text
.globl reset_vector
reset_vector:

# setup mtvec
1:      auipc   t0, %pcrel_hi(mtvec)        # load mtvec(hi)
        addi    t0, t0, %pcrel_lo(1b)       # load mtvec(lo)
        ori     t0, t0, 0b10                # enable CLIC
        csrrw   zero, mtvec, t0

# set mstatus.MIE=1 (enable M mode interrupt)
        li      t0, (1 << 3)
        csrrs   zero, mstatus, t0

# set mie.MTIE=1 (enable M mode timer interrupts)
        li      t0, (1 << 7)
        csrrs   zero, mie, t0

# load the cliccfg address and configure mode+level+priority
        li      a0, (CLIC_BASE + CLIC_MMODE_OFFSET + CLIC_CFG_OFFSET)

# set cliccfg level bits=2
        li      t0, 0b0100
        sb      t0, (a0)

# load the clicintie address and enable MTI
        li      a0, (CLIC_BASE + CLIC_MMODE_OFFSET + CLIC_INTIE_OFFSET)
        li      t0, 1
        sb      t0, (MTI)(a0)

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
.align 6
mtvec:
        csrrw   s0, mcause, zero
        bgez    s0, fail
        slli    s0, s0, 1
        srli    s0, s0, 1
        li      s1, MTI
        bne     s0, s1, fail
        j       pass

.include "qemu-tests/common-footer.s"
