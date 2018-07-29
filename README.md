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

The RISC-V testsuite is built as a submodule. QEMU specific
tests are built and executed when running `make check`.
riscv-tests are build and executed when running `make check-all`.

Run qemu-tests:

```
make check
```

Run qemu-tests showing executed commands:

```
make check VERBOSE=1
```

Run qemu-tests with interrupt tracing:

```
make check TRACE=intr
```

Run qemu-tests showing executed commands with interrupt tracing:

```
make check TRACE=intr VERBOSE=1
```

Run qemu-tests and riscv-tests:

```
git submodule update --init --recursive
make check-all
```
