# Copyright 2023 EPFL
# Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
#
# Author: Simone Machetti - simone.machetti@epfl.ch

#!/bin/bash

# This macro is used to generate:
#
# - 1KB bank: 256 words of 32-bit
#
export SNPSLMD_LICENSE_FILE=27020@edalicsrv.epfl.ch
mkdir -p build
make MUX=2 NUM_ROWS=256 NUM_BITS=32 rf > "./build/rf256x32m2.log"
