# qemu-riscv-tests

This repository builds and runs riscv-tests and qemu-tests
`in qemu-system-riscv32` and `qemu-system-riscv64`. riscv-tests
are run on the spike machine and some simple privileged
mode tests are run on the sifive_e and sifive_u machines.

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

## Running the tests

The RISC-V testsuite is built as a submodule and QEMU specific
tests are built when running `make check`.

```
git submodule update --init --recursive
make check
```
