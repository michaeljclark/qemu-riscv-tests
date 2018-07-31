# qemu-riscv-tests

This repository builds and runs riscv-tests and qemu-tests
`in qemu-system-riscv32` and `qemu-system-riscv64`. riscv-tests
are run on the spike machine and some simple privileged
mode tests are run on the sifive_e and sifive_u machines.

CLIC tests require the `sifive-clic` branch from SiFive's
_riscv-qemu_ repository:

- https://github.com/sifive/riscv-qemu/tree/sifive-clic

**Note:** this repository is called _qemu-riscv-tests_ and all
tests are run in the RISC-V QEMU full system emulator. The
_riscv-qemu-tests_ repository contains user-mode ports of
_riscv-tests_ that run in the RISC-V QEMU user-mode simulator.

- https://github.com/arsv/riscv-qemu-tests

## Build dependencies

These tests depend on the RISC-V GNU Embedded Toolchain
configured with multilib:

```
git clone https://github.com/riscv/riscv-gnu-toolchain.git
cd riscv-gnu-toolchain
git submodule update --init --recursive
mkdir build
cd build
../configure --enable-multilib
make -j$(nproc)
```

## Environment variables

The tests locate QEMU and the RISC-V compiler from your PATH.
To override the compiler prefix, set the `RISCV_PREFIX` environment
variable. The default toolchain prefix is "`riscv64-unknown-elf-`".

```
export RISCV_PREFIX=riscv64-unknown-elf-
```

## Running the tests

The RISC-V testsuite is built as a submodule. QEMU specific
tests are built and executed when running `make check`.
riscv-tests are build and executed when running `make check-all`.

#### Run qemu-tests

```
make check
```

#### Run qemu-tests showing executed commands

```
make check VERBOSE=1
```

#### Run qemu-tests with interrupt tracing enabled

```
make check TRACE=intr
```

#### Run qemu-tests showing executed commands with interrupt tracing enabled

```
make check TRACE=intr VERBOSE=1
```

#### Run qemu-tests and riscv-tests

```
git submodule update --init --recursive
make check-all
```
