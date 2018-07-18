# pass/fail indication

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
