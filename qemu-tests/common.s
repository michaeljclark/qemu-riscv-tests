# SiFive Test Finisher
.equ TEST_BASE,     0x00100000
.equ TEST_PASS,     0x5555
.equ TEST_FAIL,     0x3333

# SiFive CLINT
.equ CLINT_BASE,    0x02000000
.equ CLINT_TIMECMP, 0x4000
.equ CLINT_TIME,    0xbff8

# SiFive UART
.equ UART_BASE,     0x10013000
.equ UART_TX,       0x0
.equ UART_RX,       0x4

# local interrupts
.equ USI,           0           # User software interrupt
.equ SSI,           1           # Supervisor software interrupt
.equ HSI,           2           # (Reserved)
.equ MSI,           3           # Machine software interrupt
.equ UTI,           4           # User timer interrupt
.equ STI,           5           # Supervisor timer interrupt
.equ HTI,           6           # (Reserved)
.equ MTI,           7           # Machine timer interrupt
.equ UEI,           8           # User external interrupt
.equ SEI,           9           # Supervisor external interrupt
.equ HEI,           10          # (Reserved)
.equ MEI,           11          # Machine external interrupt
