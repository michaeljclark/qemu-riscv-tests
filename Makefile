CROSS_COMPILER=riscv64-unknown-elf

CC_32=$(CROSS_COMPILER)-gcc -march=rv32imac -mabi=ilp32
CC_64=$(CROSS_COMPILER)-gcc -march=rv64imac -mabi=lp64
AS_32=$(CROSS_COMPILER)-as -march=rv32imac -mabi=ilp32
AS_64=$(CROSS_COMPILER)-as -march=rv64imac -mabi=lp64
AR=$(CROSS_COMPILER)-ar

QEMU_SYSTEM_RISCV32=qemu-system-riscv32
QEMU_SYSTEM_RISCV64=qemu-system-riscv64

CLFAGS=
LDFLAGS=-nostartfiles -nostdlib -static
QEMU_OPTS=-nographic

SIFIVE_U_LD_SCRIPT=conf/dram_0x80000000.lds
SIFIVE_E_LD_SCRIPT=conf/nvram_0x20400000.lds

transform_machine = $(subst sifive_ex,sifive_e,$(subst sifive_ux,sifive_u,$(1)))
test_programs = $(call transform_machine,$(addprefix build/bin/rv32/, $(1)) $(addprefix build/bin/rv64/, $(1)))
test_targets = $(addprefix test-rv32-, $(1)) $(addprefix test-rv64-, $(1))
qemu_trace_opts = $(subst $(space),$(comma),$(addprefix trace:,$(1)))

TESTS = \
	clint-timer-interrupt-sifive_e \
	clint-timer-interrupt-sifive_u \
	clint-timer-interrupt-sifive_ex \
	clint-timer-interrupt-sifive_ux \
	clint-vectored-interrupt-sifive_e \
	clint-vectored-interrupt-sifive_u \
	clint-vectored-interrupt-sifive_ex \
	clint-vectored-interrupt-sifive_ux \
	clic-configure-cfg-m-sifive_ex \
	clic-configure-cfg-s-sifive_ux \
	clic-configure-intcfg-m-sifive_ex \
	clic-configure-intcfg-s-sifive_ux \
	clic-configure-intie-sifive_ex \
	clic-configure-intie-sifive_ux \
	clic-timer-interrupt-sifive_ex \
	clic-timer-interrupt-sifive_ux

comma:= ,
empty:=
space:= $(empty) $(empty)

QEMU_TRACE_INTR= \
	riscv_trap \
	sifive_clic_cfg \
	sifive_clic_intcfg \
	sifive_clic_ie \
	sifive_clic_ip \
	sifive_clic_irq

ifeq ($(QEMU_TRACE),intr)
QEMU_OPTS += -d $(call qemu_trace_opts,$(QEMU_TRACE_INTR))
endif

TEST_PROGRAMS = $(call test_programs,$(TESTS))
TEST_TARGETS = $(call test_targets,$(TESTS))

all: $(TEST_PROGRAMS)

check: qemu-tests

check-all: all riscv-tests qemu-tests

qemu-tests: $(TEST_TARGETS)

riscv-tests: riscv-tests-rv32 riscv-tests-rv64

riscv-tests-%: build-riscv-tests
	ALL_TESTS=$$(find riscv-tests/build/isa -name '$(subst riscv-tests-,,$@)*-v-*' -a ! -name '*.dump'  | sort); \
	QEMU_BIN=$(subst riscv-tests-rv32,$(QEMU_SYSTEM_RISCV32),$(subst riscv-tests-rv64,$(QEMU_SYSTEM_RISCV64),$@)); \
	for i in $${ALL_TESTS}; do \
		test=$$(basename $$i); echo $${test}; \
		$${QEMU_BIN} $(QEMU_OPTS) -machine spike_v1.10 -kernel $${i}; \
	done

build-riscv-tests:
	@test -d riscv-tests/build || ( \
		mkdir riscv-tests/build; \
		cd riscv-tests/build; \
		../configure --host=$(CROSS_COMPILER); \
		make -j$$(nproc); \
	)

test-rv32-%-sifive_e: build/bin/rv32/%-sifive_e
	@echo -n "$@\t" ; $(QEMU_SYSTEM_RISCV32) $(QEMU_OPTS) -machine sifive_e -kernel build/bin/rv32/$*-sifive_e

test-rv64-%-sifive_e: build/bin/rv64/%-sifive_e
	@echo -n "$@\t" ; $(QEMU_SYSTEM_RISCV64) $(QEMU_OPTS) -machine sifive_e -kernel build/bin/rv64/$*-sifive_e

test-rv32-%-sifive_u: build/bin/rv32/%-sifive_u
	@echo -n "$@\t" ; $(QEMU_SYSTEM_RISCV32) $(QEMU_OPTS) -machine sifive_u -kernel build/bin/rv32/$*-sifive_u

test-rv64-%-sifive_u: build/bin/rv64/%-sifive_u
	@echo -n "$@\t" ; $(QEMU_SYSTEM_RISCV64) $(QEMU_OPTS) -machine sifive_u -kernel build/bin/rv64/$*-sifive_u

test-rv32-%-sifive_ex: build/bin/rv32/%-sifive_e
	@echo -n "$@\t" ; $(QEMU_SYSTEM_RISCV32) $(QEMU_OPTS) -machine sifive_ex -kernel build/bin/rv32/$*-sifive_e

test-rv64-%-sifive_ex: build/bin/rv64/%-sifive_e
	@echo -n "$@\t" ; $(QEMU_SYSTEM_RISCV64) $(QEMU_OPTS) -machine sifive_ex -kernel build/bin/rv64/$*-sifive_e

test-rv32-%-sifive_ux: build/bin/rv32/%-sifive_u
	@echo -n "$@\t" ; $(QEMU_SYSTEM_RISCV32) $(QEMU_OPTS) -machine sifive_ux -kernel build/bin/rv32/$*-sifive_u

test-rv64-%-sifive_ux: build/bin/rv64/%-sifive_u
	@echo -n "$@\t" ; $(QEMU_SYSTEM_RISCV64) $(QEMU_OPTS) -machine sifive_ux -kernel build/bin/rv64/$*-sifive_u

clean:
	rm -fr build

build/obj/rv32/%.o: qemu-tests/%.s
	@echo AS.32 $@ ; mkdir -p $(@D) ; $(AS_32) $(CFLAGS) $^ -o $@

build/obj/rv64/%.o: qemu-tests/%.s
	@echo AS.64 $@ ; mkdir -p $(@D) ; $(AS_64) $(CFLAGS) $^ -o $@

build/bin/rv32/%-sifive_e: build/obj/rv32/%.o
	@echo LD.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(LDFLAGS) -T ${SIFIVE_E_LD_SCRIPT} $^ -o $@

build/bin/rv64/%-sifive_e: build/obj/rv64/%.o
	@echo LD.64 $@ ; mkdir -p $(@D) ; $(CC_64) $(LDFLAGS) -T ${SIFIVE_E_LD_SCRIPT} $^ -o $@

build/bin/rv32/%-sifive_u: build/obj/rv32/%.o
	@echo LD.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(LDFLAGS) -T ${SIFIVE_U_LD_SCRIPT} $^ -o $@

build/bin/rv64/%-sifive_u: build/obj/rv64/%.o
	@echo LD.64 $@ ; mkdir -p $(@D) ; $(CC_64) $(LDFLAGS) -T ${SIFIVE_U_LD_SCRIPT} $^ -o $@
