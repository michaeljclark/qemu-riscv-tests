CROSS_COMPILER=riscv64-unknown-elf

CC_32=$(CROSS_COMPILER)-gcc -march=rv32imac -mabi=ilp32
CC_64=$(CROSS_COMPILER)-gcc -march=rv64imac -mabi=lp64
AS_32=$(CROSS_COMPILER)-as -march=rv32imac -mabi=ilp32
AS_64=$(CROSS_COMPILER)-as -march=rv64imac -mabi=lp64
AR=$(CROSS_COMPILER)-ar

CLFAGS=
LDFLAGS=-nostartfiles -nostdlib -static

SIFIVE_U_LD_SCRIPT=conf/dram_0x80000000.lds
SIFIVE_E_LD_SCRIPT=conf/nvram_0x20400000.lds

TEST_PROGRAMS = \
	build/bin/riscv32/timer-interrupt-sifive_e \
	build/bin/riscv64/timer-interrupt-sifive_e \
	build/bin/riscv32/timer-interrupt-sifive_u \
	build/bin/riscv64/timer-interrupt-sifive_u \
	build/bin/riscv32/vectored-interrupt-sifive_e \
	build/bin/riscv64/vectored-interrupt-sifive_e \
	build/bin/riscv32/vectored-interrupt-sifive_u \
	build/bin/riscv64/vectored-interrupt-sifive_u

all: $(TEST_PROGRAMS)

check: all run-riscv-tests run-qemu-tests

run-qemu-tests: build-riscv-tests \
	test-riscv32-timer-interrupt-sifive_e \
	test-riscv64-timer-interrupt-sifive_e \
	test-riscv32-timer-interrupt-sifive_u \
	test-riscv64-timer-interrupt-sifive_u \
	test-riscv32-vectored-interrupt-sifive_e \
	test-riscv64-vectored-interrupt-sifive_e \
	test-riscv32-vectored-interrupt-sifive_u \
	test-riscv64-vectored-interrupt-sifive_u

run-riscv-tests: build-riscv-tests
	ALL_TESTS=$$(find riscv-tests/build/isa -name 'rv64*-v-*' -a ! -name '*.dump'  | sort); \
	for i in $${ALL_TESTS}; do \
		test=$$(basename $$i); echo $${test}; \
		qemu-system-riscv64 -nographic -machine spike_v1.10 -kernel $${i}; \
	done

build-riscv-tests:
	test -d riscv-tests/build || ( \
		mkdir riscv-tests/build; \
		cd riscv-tests/build; \
		../configure --host=$(CROSS_COMPILER); \
		make -j$$(nproc); \
	)

test-riscv32-%-sifive_e: build/bin/riscv32/%-sifive_e
	qemu-system-riscv32 -nographic -machine sifive_e -kernel build/bin/riscv32/$*-sifive_e

test-riscv64-%-sifive_e: build/bin/riscv64/%-sifive_e
	qemu-system-riscv64 -nographic -machine sifive_e -kernel build/bin/riscv64/$*-sifive_e

test-riscv32-%-sifive_u: build/bin/riscv32/%-sifive_u
	qemu-system-riscv32 -nographic -machine sifive_u -kernel build/bin/riscv32/$*-sifive_u

test-riscv64-%-sifive_u: build/bin/riscv64/%-sifive_u
	qemu-system-riscv64 -nographic -machine sifive_u -kernel build/bin/riscv64/$*-sifive_u

clean:
	rm -fr build

build/obj/riscv32/%.o: qemu-tests/%.s
	@echo AS.32 $@ ; mkdir -p $(@D) ; $(AS_32) $(CFLAGS) $^ -o $@

build/obj/riscv64/%.o: qemu-tests/%.s
	@echo AS.64 $@ ; mkdir -p $(@D) ; $(AS_64) $(CFLAGS) $^ -o $@

build/bin/riscv32/%-sifive_e: build/obj/riscv32/%.o
	@echo LD.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(LDFLAGS) -T ${SIFIVE_E_LD_SCRIPT} $^ -o $@

build/bin/riscv64/%-sifive_e: build/obj/riscv64/%.o
	@echo LD.64 $@ ; mkdir -p $(@D) ; $(CC_64) $(LDFLAGS) -T ${SIFIVE_E_LD_SCRIPT} $^ -o $@

build/bin/riscv32/%-sifive_u: build/obj/riscv32/%.o
	@echo LD.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(LDFLAGS) -T ${SIFIVE_U_LD_SCRIPT} $^ -o $@

build/bin/riscv64/%-sifive_u: build/obj/riscv64/%.o
	@echo LD.64 $@ ; mkdir -p $(@D) ; $(CC_64) $(LDFLAGS) -T ${SIFIVE_U_LD_SCRIPT} $^ -o $@
