# Copyright 2023 EPFL
# Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
#
# Author: Simone Machetti - simone.machetti@epfl.ch

MEM_HIER ?= CACHE
APP_NAME ?= vec_copy
SIM_GUI  ?= 0

VX_CC  = $(RISCV_TOOLCHAIN_PATH)/bin/riscv32-unknown-elf-gcc
VX_DP  = $(RISCV_TOOLCHAIN_PATH)/bin/riscv32-unknown-elf-objdump
VX_CP  = $(RISCV_TOOLCHAIN_PATH)/bin/riscv32-unknown-elf-objcopy

VX_CFLAGS  += -march=rv32imf -mabi=ilp32f -O3 -Wstack-usage=1024 -ffreestanding -nostartfiles -fdata-sections -ffunction-sections
VX_LDFLAGS += -Wl,-Bstatic,-T,$(GPGPU_HOME)/sw/link/link32.ld -Wl,--gc-sections
VX_SRCS     = $(GPGPU_HOME)/sw/apps/$(APP_NAME)/src/kernel.c $(GPGPU_HOME)/sw/startup/ctr0.S

all: kernel.bin kernel.dump

kernel.elf: $(VX_SRCS)
	mkdir -p $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build
	$(VX_CC) $(VX_CFLAGS) $(VX_SRCS) $(VX_LDFLAGS) -o $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.elf

ifeq ($(MEM_HIER), CACHE)

kernel.bin: kernel.elf
	$(VX_CP) -O binary $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.elf $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.bin
	mkdir -p $(GPGPU_HOME)/hw/imp/sim/input
	python3 $(GPGPU_HOME)/sw/tools/bin2mem.py $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.bin $(GPGPU_HOME)/hw/imp/sim/input/kernel.mem

else

kernel.bin: kernel.elf
	$(VX_CP) -O binary -j .start -j .text $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.elf $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build/kernel_instr.bin
	$(VX_CP) -O binary -R .start -R .text $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.elf $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build/kernel_data.bin
	mkdir -p $(GPGPU_HOME)/hw/imp/sim/input
	python3 $(GPGPU_HOME)/sw/tools/bin2mem.py $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build/kernel_instr.bin $(GPGPU_HOME)/hw/imp/sim/input/kernel_instr.mem
	python3 $(GPGPU_HOME)/sw/tools/bin2mem.py $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build/kernel_data.bin $(GPGPU_HOME)/hw/imp/sim/input/kernel_data.mem

endif

kernel.dump: kernel.elf
	$(VX_DP) -D $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.elf > $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.dump

ifeq ($(SIM_GUI), 0)

sim:
	cd $(GPGPU_HOME)/sw/apps/$(APP_NAME) && \
	mkdir -p $(GPGPU_HOME)/hw/imp/sim/output && \
	export SEL_MEM_HIER=$(MEM_HIER) && \
	export SEL_SIM_GUI=$(SIM_GUI) && \
	vsim -c -do $(GPGPU_HOME)/hw/imp/sim/scripts/gpgpu.tcl && \
	mv $(GPGPU_HOME)/sw/apps/$(APP_NAME)/output.vcd $(GPGPU_HOME)/hw/imp/sim/output

else

sim:
	cd $(GPGPU_HOME)/sw/apps/$(APP_NAME) && \
	mkdir -p $(GPGPU_HOME)/hw/imp/sim/output && \
	export SEL_MEM_HIER=$(MEM_HIER) && \
	export SEL_SIM_GUI=$(SIM_GUI) && \
	vsim -gui -do $(GPGPU_HOME)/hw/imp/sim/scripts/gpgpu.tcl && \
	mv $(GPGPU_HOME)/sw/apps/$(APP_NAME)/output.vcd $(GPGPU_HOME)/hw/imp/sim/output

endif

wave:
	gtkwave $(GPGPU_HOME)/hw/imp/sim/output/output.vcd &

syn:
	cd $(GPGPU_HOME)/hw/imp/syn && \
	mkdir -p $(GPGPU_HOME)/hw/imp/syn/output && \
	mkdir -p $(GPGPU_HOME)/hw/imp/syn/report && \
	mkdir -p $(GPGPU_HOME)/hw/imp/syn/work && \
	cd $(GPGPU_HOME)/hw/imp/syn/work && \
	export SEL_MEM_HIER=$(MEM_HIER) && \
	dc_shell -f $(GPGPU_HOME)/hw/imp/syn/scripts/gpgpu.tcl && \
	exit

clean:
	rm -rf $(GPGPU_HOME)/sw/apps/$(APP_NAME)/build
	rm -rf $(GPGPU_HOME)/sw/apps/$(APP_NAME)/work
	rm -rf $(GPGPU_HOME)/sw/apps/$(APP_NAME)/transcript
	rm -rf $(GPGPU_HOME)/hw/imp/sim/input
	rm -rf $(GPGPU_HOME)/hw/imp/sim/output
