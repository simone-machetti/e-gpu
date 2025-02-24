# Copyright 2023 EPFL
# Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
#
# Author: Simone Machetti - simone.machetti@epfl.ch

APP_NAME ?= vec_add
SIM_GUI  ?= 0

VORTEX = $(E_GPU_HOME)/hw/src/vendor/vortex

VX_CC  = $(RISCV_TOOLCHAIN_PATH)/bin/riscv32-unknown-elf-gcc
VX_DP  = $(RISCV_TOOLCHAIN_PATH)/bin/riscv32-unknown-elf-objdump
VX_CP  = $(RISCV_TOOLCHAIN_PATH)/bin/riscv32-unknown-elf-objcopy

VX_CFLAGS  += -march=rv32imf -mabi=ilp32f -O3 -Wstack-usage=1024 -ffreestanding -nostartfiles -fdata-sections -ffunction-sections
VX_CFLAGS  += -I$(E_GPU_HOME)/hw/src/vendor/vortex/runtime/include -I$(E_GPU_HOME)/sw/lib/include
VX_LDFLAGS += -Wl,-Bstatic,-T,$(E_GPU_HOME)/sw/link/link32.ld -Wl,--gc-sections
VX_SRCS     = $(E_GPU_HOME)/sw/apps/$(APP_NAME)/src/kernel.c $(E_GPU_HOME)/sw/lib/src/e_gpu_scheduler.c $(E_GPU_HOME)/sw/startup/ctr0.S

all: clean-app kernel.bin kernel.dump

kernel.elf: $(VX_SRCS)
	mkdir -p $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build
	$(VX_CC) $(VX_CFLAGS) $(VX_SRCS) $(VX_LDFLAGS) -o $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.elf

kernel.bin: kernel.elf
	$(VX_CP) -O binary $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.elf $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.bin
	mkdir -p $(E_GPU_HOME)/hw/imp/sim/input
	cp $(E_GPU_HOME)/sw/apps/$(APP_NAME)/src/host.vh $(E_GPU_HOME)/hw/imp/sim/input
	python3 $(E_GPU_HOME)/sw/tools/bin2mem.py $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.bin $(E_GPU_HOME)/hw/imp/sim/input/kernel.mem

kernel.dump: kernel.elf
	$(VX_DP) -D $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.elf > $(E_GPU_HOME)/sw/apps/$(APP_NAME)/build/kernel.dump

ifeq ($(SIM_GUI), 0)

sim:
	cd $(E_GPU_HOME)/sw/apps/$(APP_NAME) && \
	mkdir -p $(E_GPU_HOME)/hw/imp/sim/output && \
	export SEL_SIM_GUI=$(SIM_GUI) && \
	vsim -c -do $(E_GPU_HOME)/hw/imp/sim/scripts/e_gpu.tcl && \
	mv $(E_GPU_HOME)/sw/apps/$(APP_NAME)/output.vcd $(E_GPU_HOME)/hw/imp/sim/output

else

sim:
	cd $(E_GPU_HOME)/sw/apps/$(APP_NAME) && \
	mkdir -p $(E_GPU_HOME)/hw/imp/sim/output && \
	export SEL_SIM_GUI=$(SIM_GUI) && \
	vsim -gui -do $(E_GPU_HOME)/hw/imp/sim/scripts/e_gpu.tcl && \
	mv $(E_GPU_HOME)/sw/apps/$(APP_NAME)/output.vcd $(E_GPU_HOME)/hw/imp/sim/output

endif

wave:
	gtkwave $(E_GPU_HOME)/hw/imp/sim/output/output.vcd &

vendor: clean-vendor
	cd $(E_GPU_HOME)/hw/src/vendor && \
	python3 vendor.py vortex.vendor.hjson --update && \
	python3 $(VORTEX)/hw/scripts/gen_config.py -i $(VORTEX)/hw/rtl/VX_config.vh -o $(VORTEX)/runtime/include/VX_config.h && \
	python3 vendor.py common_cells.vendor.hjson --update && \
	python3 vendor.py crossbar.vendor.hjson --update

sram:
	cd $(E_GPU_HOME)/hw/src/rtl/common/mem/arm_sram && \
	./gen_sram.sh

clean: clean-app

clean-app:
	for app in $(wildcard $(E_GPU_HOME)/sw/apps/*); do rm -rf $$app/build $$app/work $$app/transcript; done
	rm -rf $(E_GPU_HOME)/hw/imp/sim/input
	rm -rf $(E_GPU_HOME)/hw/imp/sim/output

clean-vendor:
	rm -rf $(E_GPU_HOME)/hw/src/vendor/vortex
	rm -rf $(E_GPU_HOME)/hw/src/vendor/vortex.lock.hjson
	rm -rf $(E_GPU_HOME)/hw/src/vendor/common_cells
	rm -rf $(E_GPU_HOME)/hw/src/vendor/common_cells.lock.hjson
	rm -rf $(E_GPU_HOME)/hw/src/vendor/crossbar
	rm -rf $(E_GPU_HOME)/hw/src/vendor/crossbar.lock.hjson

clean-sram:
	rm -rf $(E_GPU_HOME)/hw/src/rtl/common/mem/arm_sram/build
	rm -rf $(E_GPU_HOME)/hw/src/rtl/common/mem/arm_sram/rf256x32m2
