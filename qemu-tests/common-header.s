# See LICENSE for license details.

# Privileged ISA constants

.equ MIE_USIE,              0x00000001
.equ MIE_SSIE,              0x00000002
.equ MIE_HSIE,              0x00000004
.equ MIE_MSIE,              0x00000008
.equ MIE_UTIE,              0x00000010
.equ MIE_STIE,              0x00000020
.equ MIE_HTIE,              0x00000040
.equ MIE_MTIE,              0x00000080
.equ MIE_UEIE,              0x00000010
.equ MIE_SEIE,              0x00000020
.equ MIE_HEIE,              0x00000040
.equ MIE_MEIE,              0x00000080

.equ MIP_USIP,              0x00000001
.equ MIP_SSIP,              0x00000002
.equ MIP_HSIP,              0x00000004
.equ MIP_MSIP,              0x00000008
.equ MIP_UTIP,              0x00000010
.equ MIP_STIP,              0x00000020
.equ MIP_HTIP,              0x00000040
.equ MIP_MTIP,              0x00000080
.equ MIP_UEIP,              0x00000010
.equ MIP_SEIP,              0x00000020
.equ MIP_HEIP,              0x00000040
.equ MIP_MEIP,              0x00000080

.equ MSTATUS_UIE,           0x00000001
.equ MSTATUS_SIE,           0x00000002
.equ MSTATUS_HIE,           0x00000004
.equ MSTATUS_MIE,           0x00000008
.equ MSTATUS_UPIE,          0x00000010
.equ MSTATUS_SPIE,          0x00000020
.equ MSTATUS_HPIE,          0x00000040
.equ MSTATUS_MPIE,          0x00000080
.equ MSTATUS_SPP,           0x00000100
.equ MSTATUS_HPP,           0x00000600
.equ MSTATUS_MPP,           0x00001800
.equ MSTATUS_FS,            0x00006000
.equ MSTATUS_XS,            0x00018000
.equ MSTATUS_MPRV,          0x00020000
.equ MSTATUS_SUM,           0x00040000
.equ MSTATUS_MXR,           0x00080000

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
