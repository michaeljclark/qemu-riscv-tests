.include "qemu-tests/common.s"

.section .text
.globl reset_vector
reset_vector:

# setup mtvec
1:      auipc   t0, %pcrel_hi(mtvec)        # load mtvec(hi)
        addi    t0, t0, %pcrel_lo(1b)       # load mtvec(lo)
        csrrw   zero, mtvec, t0

# set mstatus.MIE=1 (enable M mode interrupt)
        li      t0, 8
        csrrs   zero, mstatus, t0

# set mie.MTIE=1 (enable M mode timer interrupts)
        li      t0, 128
        csrrs   zero, mie, t0

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
.align 3
mtvec:
        csrrw   s0, mcause, zero
        bgez    s0, fail
        slli    s0, s0, 1
        srli    s0, s0, 1
        li      s1, MTI
        bne     s0, s1, fail
        j pass

pass:
        la a0, pass_msg
        jal puts
        j shutdown

fail:
        la a0, fail_msg
        jal puts
        j shutdown

puts:
        li a2, UART_BASE
1:      lbu a1, (a0)
        beqz a1, 3f
2:      lw a3, UART_TX(a2)
        bltz a3, 2b
        sw a1, UART_TX(a2)
        addi a0, a0, 1
        j 1b
3:      ret

shutdown:
        li      a0, TEST_BASE
        li      a1, TEST_PASS
        sw      a1, 0(a0)
1:      j 1b

.section .data

pass_msg:
        .string "PASS\n"

fail_msg:
        .string "FAIL\n"
