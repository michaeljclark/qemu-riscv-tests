RISCV_PREFIX ?= riscv64-unknown-elf-

CC_32 = $(RISCV_PREFIX)gcc -march=rv32imac -mabi=ilp32
CC_64 = $(RISCV_PREFIX)gcc -march=rv64imac -mabi=lp64
AS_32 = $(RISCV_PREFIX)as -march=rv32imac -mabi=ilp32
AS_64 = $(RISCV_PREFIX)as -march=rv64imac -mabi=lp64
AR    = $(RISCV_PREFIX)ar

QEMU_SYSTEM_RISCV32 ?= qemu-system-riscv32
QEMU_SYSTEM_RISCV64 ?= qemu-system-riscv64

QEMU_OPTS = -nographic

CLFAGS  =
LDFLAGS = -nostartfiles -nostdlib -static
OBJ_DIR = build/obj
BIN_DIR = build/bin

SIFIVE_U_LD_SCRIPT = conf/dram_0x80000000.lds
SIFIVE_E_LD_SCRIPT = conf/nvram_0x20400000.lds

TESTS = \
	clint-timer-interrupt-sifive_e \
	clint-timer-interrupt-sifive_u \
	clint-timer-interrupt-sifive_ex \
	clint-timer-interrupt-sifive_ux \
	clint-vectored-interrupt-sifive_e \
	clint-vectored-interrupt-sifive_u \
	clint-vectored-interrupt-sifive_ex \
	clint-vectored-interrupt-sifive_ux \
	clic-configure-cfg-e-sifive_ex \
	clic-configure-cfg-u-sifive_ux \
	clic-configure-intcfg-e-sifive_ex \
	clic-configure-intcfg-u-sifive_ux \
	clic-configure-intie-sifive_ex \
	clic-configure-intie-sifive_ux \
	clic-timer-interrupt-sifive_ex \
	clic-timer-interrupt-sifive_ux

QEMU_TRACE_INTR= \
	riscv_trap \
	sifive_clic_cfg \
	sifive_clic_intcfg \
	sifive_clic_ie \
	sifive_clic_ip \
	sifive_clic_irq

comma:= ,
empty:=
space:= $(empty) $(empty)
machine_transform = $(subst sifive_ex,sifive_e,$(subst sifive_ux,sifive_u,$(1)))
qemu_trace_opts = $(subst $(space),$(comma),$(addprefix trace:,$(1)))
qemu_sys_rv32 = $(QEMU_SYSTEM_RISCV32)
qemu_sys_rv64 = $(QEMU_SYSTEM_RISCV64)
qemu_kernel = $(BIN_DIR)/$(1)/$(3)-$(call machine_transform,$(2))
run_test = echo $(if $(QEMU_TRACE),,-n) "$(4)\t" ; \
	$(qemu_sys_$(1)) $(QEMU_OPTS) -machine $(2) \
	-kernel $(call qemu_kernel,$(1),$(2),$(3))
test_programs = \
	$(addprefix $(BIN_DIR)/rv32/, $(call machine_transform,$(1))) \
	$(addprefix $(BIN_DIR)/rv64/, $(call machine_transform,$(1)))
test_targets = $(addprefix test-rv32-, $(1)) \
	$(addprefix test-rv64-, $(1))

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
	ALL_TESTS=$$(find riscv-tests/build/isa -name \
		'$(subst riscv-tests-,,$@)*-v-*' -a ! -name '*.dump'  | sort); \
	QEMU_BIN=$(qemu_sys_$(subst riscv-tests-,,$@)); \
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

test-rv32-%-sifive_e: $(BIN_DIR)/rv32/%-sifive_e ; @$(call run_test,rv32,sifive_e,$*,$@)
test-rv64-%-sifive_e: $(BIN_DIR)/rv64/%-sifive_e ; @$(call run_test,rv64,sifive_e,$*,$@)
test-rv32-%-sifive_u: $(BIN_DIR)/rv32/%-sifive_u ; @$(call run_test,rv32,sifive_u,$*,$@)
test-rv64-%-sifive_u: $(BIN_DIR)/rv64/%-sifive_u ; @$(call run_test,rv64,sifive_u,$*,$@)
test-rv32-%-sifive_ex: $(BIN_DIR)/rv32/%-sifive_e ; @$(call run_test,rv32,sifive_ex,$*,$@)
test-rv64-%-sifive_ex: $(BIN_DIR)/rv64/%-sifive_e ; @$(call run_test,rv64,sifive_ex,$*,$@)
test-rv32-%-sifive_ux: $(BIN_DIR)/rv32/%-sifive_u ; @$(call run_test,rv32,sifive_ux,$*,$@)
test-rv64-%-sifive_ux: $(BIN_DIR)/rv64/%-sifive_u ; @$(call run_test,rv64,sifive_ux,$*,$@)

clean:
	rm -fr build

$(OBJ_DIR)/rv32/%.o: qemu-tests/%.s
	@echo AS.32 $@ ; mkdir -p $(@D) ; $(AS_32) $(CFLAGS) $^ -o $@

$(OBJ_DIR)/rv64/%.o: qemu-tests/%.s
	@echo AS.64 $@ ; mkdir -p $(@D) ; $(AS_64) $(CFLAGS) $^ -o $@

$(BIN_DIR)/rv32/%-sifive_e: $(OBJ_DIR)/rv32/%.o
	@echo LD.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(LDFLAGS) -T ${SIFIVE_E_LD_SCRIPT} $^ -o $@

$(BIN_DIR)/rv64/%-sifive_e: $(OBJ_DIR)/rv64/%.o
	@echo LD.64 $@ ; mkdir -p $(@D) ; $(CC_64) $(LDFLAGS) -T ${SIFIVE_E_LD_SCRIPT} $^ -o $@

$(BIN_DIR)/rv32/%-sifive_u: $(OBJ_DIR)/rv32/%.o
	@echo LD.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(LDFLAGS) -T ${SIFIVE_U_LD_SCRIPT} $^ -o $@

$(BIN_DIR)/rv64/%-sifive_u: $(OBJ_DIR)/rv64/%.o
	@echo LD.64 $@ ; mkdir -p $(@D) ; $(CC_64) $(LDFLAGS) -T ${SIFIVE_U_LD_SCRIPT} $^ -o $@
