# Copyright 2023 EPFL
# Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
#
# Author: Simone Machetti - simone.machetti@epfl.ch

source $env(E_GPU_HOME)/hw/imp/sim/scripts/e_gpu_compile.tcl

if {$env(SEL_MEM_HIER) == "CACHE"} {

    vlog -work work $env(E_GPU_HOME)/hw/src/tb/dual_port_ram.sv
    vlog -work work $env(E_GPU_HOME)/hw/src/tb/tb_cache.sv

} else {

    vlog -work work $env(E_GPU_HOME)/hw/src/tb/tb_scratchpad.sv

}

vsim -gui -wlf ./build/e_gpu.wlf work.testbench -voptargs="+acc"

if {!$env(SEL_SIM_GUI)} {

    run -all
    exit

}
