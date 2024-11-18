# Copyright 2023 EPFL
# Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
#
# Author: Simone Machetti - simone.machetti@epfl.ch

#!/bin/bash

# RISC-V toolchain
export RISCV_TOOLCHAIN_PATH=/e_gpu_tools/riscv-gnu-toolchain

# Repository home
export E_GPU_HOME=$(pwd)

# Questa path
export PATH="/e_gpu_tools/qsta/2020.4/linux_x86_64:$PATH"

# Questa license
export MGLS_LICENSE_FILE=1717@edalicsrv.epfl.ch
