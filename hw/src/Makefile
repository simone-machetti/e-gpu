# Copyright 2023 EPFL
# Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
#
# Author: Simone Machetti - simone.machetti@epfl.ch

VORTEX = $(GPGPU_HOME)/hw/src/vendor/vortex

src-gen-all: clean src-gen-vendor

src-gen-vendor:
	cd vendor && \
	python3 vendor.py vortex.vendor.hjson --update && \
	python3 $(VORTEX)/hw/scripts/gen_config.py -i $(VORTEX)/hw/rtl/VX_config.vh -o $(VORTEX)/runtime/include/VX_config.h && \
	python3 vendor.py pulp_platform_common_cells.vendor.hjson --update && \
	python3 vendor.py pulp_platform_cluster_interconnect.vendor.hjson --update

clean:
	rm -rf vendor/vortex
	rm -rf vendor/vortex.lock.hjson
	rm -rf vendor/pulp_platform_common_cells
	rm -rf vendor/pulp_platform_common_cells.lock.hjson
	rm -rf vendor/pulp_platform_cluster_interconnect
	rm -rf vendor/pulp_platform_cluster_interconnect.lock.hjson
