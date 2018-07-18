# SiFive Test Finisher
.equ TEST_BASE,             0x00100000
.equ TEST_PASS,             0x5555
.equ TEST_FAIL,             0x3333

# SiFive CLINT
.equ CLINT_BASE,            0x02000000
.equ CLINT_SIP,             0x0
.equ CLINT_TIMECMP,         0x4000
.equ CLINT_TIME,            0xbff8

# SiFive CLIC
.equ CLIC_BASE,             0x02000000
.equ CLIC_CLINT_SIZE,       0x10000
.equ CLIC_HART_SIZE,        0x1000
.equ CLIC_MMODE_OFFSET,     0x800000
.equ CLIC_SMODE_OFFSET,     0xc00000
.equ CLIC_UMODE_OFFSET,     0xe00000
.equ CLIC_INTIP_OFFSET,     0x0
.equ CLIC_INTIE_OFFSET,     0x400
.equ CLIC_INTCFG_OFFSET,    0x800
.equ CLIC_CFG_OFFSET,       0xc00

# SiFive UART
.equ UART_BASE,             0x10013000
.equ UART_TX,               0x0
.equ UART_RX,               0x4

# local interrupts
.equ USI,                   0           # User software interrupt
.equ SSI,                   1           # Supervisor software interrupt
.equ HSI,                   2           # (Reserved)
.equ MSI,                   3           # Machine software interrupt
.equ UTI,                   4           # User timer interrupt
.equ STI,                   5           # Supervisor timer interrupt
.equ HTI,                   6           # (Reserved)
.equ MTI,                   7           # Machine timer interrupt
.equ UEI,                   8           # User external interrupt
.equ SEI,                   9           # Supervisor external interrupt
.equ HEI,                   10          # (Reserved)
.equ MEI,                   11          # Machine external interrupt
