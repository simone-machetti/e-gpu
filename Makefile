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
VX_CFLAGS  += -I$(E_GPU_HOME)/hw/src/vendor/vortex/runtime/include -I$(E_GPU_HOME)/sw/lib/include
VX_LDFLAGS += -Wl,-Bstatic,-T,$(E_GPU_HOME)/sw/link/link32.ld -Wl,--gc-sections
VX_SRCS     = $(E_GPU_HOME)/sw/apps/$(APP_NAME)/src/kernel.c $(E_GPU_HOME)/sw/lib/src/e_gpu_scheduler.c $(E_GPU_HOME)/sw/startup/ctr0.S

all: kernel.bin kernel.dump

kernel.elf: $(VX_SRCS)
	mkdir -p $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build
	$(VX_CC) $(VX_CFLAGS) $(VX_SRCS) $(VX_LDFLAGS) -o $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.elf

kernel.bin: kernel.elf
	$(VX_CP) -O binary $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.elf $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.bin
	mkdir -p $(E_GPU_HOME)/hw/imp/sim/input
	python3 $(E_GPU_HOME)/sw/tools/bin2mem.py $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.bin $(E_GPU_HOME)/hw/imp/sim/input/kernel.mem

kernel.dump: kernel.elf
	$(VX_DP) -D $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.elf > $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.dump

ifeq ($(SIM_GUI), 0)

sim:
	cd $(E_GPU_HOME)/sw/apps/$(APP_NAME) && \
	mkdir -p $(E_GPU_HOME)/hw/imp/sim/output && \
	export SEL_MEM_HIER=$(MEM_HIER) && \
	export SEL_SIM_GUI=$(SIM_GUI) && \
	vsim -c -do $(E_GPU_HOME)/hw/imp/sim/scripts/e_gpu.tcl && \
	mv $(E_GPU_HOME)/sw/apps/$(APP_NAME)/output.vcd $(E_GPU_HOME)/hw/imp/sim/output

else

sim:
	cd $(E_GPU_HOME)/sw/apps/$(APP_NAME) && \
	mkdir -p $(E_GPU_HOME)/hw/imp/sim/output && \
	export SEL_MEM_HIER=$(MEM_HIER) && \
	export SEL_SIM_GUI=$(SIM_GUI) && \
	vsim -gui -do $(E_GPU_HOME)/hw/imp/sim/scripts/e_gpu.tcl && \
	mv $(E_GPU_HOME)/sw/apps/$(APP_NAME)/output.vcd $(E_GPU_HOME)/hw/imp/sim/output

endif

wave:
	gtkwave $(E_GPU_HOME)/hw/imp/sim/output/output.vcd &

clean:
	rm -rf $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build
	rm -rf $(E_GPU_HOME)/sw/apps/$(APP_NAME)/work
	rm -rf $(E_GPU_HOME)/sw/apps/$(APP_NAME)/transcript
	rm -rf $(E_GPU_HOME)/hw/imp/sim/input
	rm -rf $(E_GPU_HOME)/hw/imp/sim/output
