# Copyright 2023 EPFL
# Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
#
# Author: Simone Machetti - simone.machetti@epfl.ch

vlib work

set lib_include       +incdir+$env(GPGPU_HOME)/hw/src/rtl/include
set lib_vx_rtl        +incdir+$env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl
set lib_vx_tex_unit   +incdir+$env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/tex_unit
set lib_vx_libs       +incdir+$env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs
set lib_vx_interfaces +incdir+$env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces
set lib_vx_fp_cores   +incdir+$env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/fp_cores
set lib_vx_cache      +incdir+$env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache

# /hw/src/vendor/vortex/hw/rtl/cache
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_tag_access.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_shared_mem.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_nc_bypass.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_miss_resrv.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_flush_ctrl.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_data_access.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_core_rsp_merge.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_core_req_bank_sel.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_cache.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_bank.sv

# /hw/src/vendor/vortex/hw/rtl/interfaces
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_wstall_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_writeback_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_warp_ctl_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_tex_rsp_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_tex_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_tex_csr_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_perf_tex_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_perf_pipeline_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_perf_memsys_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_perf_cache_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_mem_rsp_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_mem_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_lsu_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_join_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_ifetch_rsp_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_ifetch_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_icache_rsp_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_icache_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_ibuffer_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_gpu_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_gpr_rsp_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_gpr_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_fpu_to_csr_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_fpu_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_fetch_to_csr_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_decode_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_dcache_rsp_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_dcache_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_csr_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_commit_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_cmt_to_csr_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_branch_ctl_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_alu_req_if.sv

# /hw/src/vendor/vortex/hw/rtl/libs
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_stream_demux.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_stream_arbiter.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_sp_ram.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_skid_buffer.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_shift_register.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_serial_div.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_scope.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_scan.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_rr_arbiter.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_reset_relay.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_priority_encoder.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_popcount.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_pipe_register.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_pending_size.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_onehot_mux.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_onehot_encoder.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_mux.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_multiplier.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_matrix_arbiter.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_lzc.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_index_queue.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_index_buffer.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_fixed_arbiter.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_find_first.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_fifo_queue.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_fair_arbiter.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_elastic_buffer.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_dp_ram.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_divider.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_bypass_buffer.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_bits_remove.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_bits_insert.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_axi_adapter.sv

# /hw/src/vendor/vortex/hw/rtl/tex_unit
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/tex_unit/VX_tex_wrap.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/tex_unit/VX_tex_unit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/tex_unit/VX_tex_stride.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/tex_unit/VX_tex_sat.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/tex_unit/VX_tex_sampler.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/tex_unit/VX_tex_mem.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/tex_unit/VX_tex_lerp.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/tex_unit/VX_tex_format.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/tex_unit/VX_tex_addr.sv

# /hw/src/vendor/vortex/hw/rtl
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_writeback.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_warp_sched.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_smem_arb.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_scoreboard.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_muldiv.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_mem_unit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_mem_arb.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_lsu_unit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_issue.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_ipdom_stack.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_icache_stage.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_ibuffer.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_gpu_unit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_gpr_stage.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_fetch.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_execute.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_dispatch.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_decode.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_csr_unit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_csr_data.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_commit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_cluster.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_cache_arb.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_alu_unit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_core.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_pipeline.sv

# /hw/src/rtl/interfaces
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/rtl/interfaces/obi_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/rtl/interfaces/obi_rsp_if.sv

# /hw/src/rtl/common
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/rtl/common/obi_bridge.sv

# /hw/src/rtl/mem_hier_cache
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/rtl/mem_hier_cache/serializer.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/rtl/mem_hier_cache/instr_cache.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/rtl/mem_hier_cache/data_cache.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/rtl/mem_hier_cache/mem_hier_cache_top.sv

# /hw/src/rtl/
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/rtl/core.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/rtl/gpgpu_top.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/rtl/dual_port_ram.sv

# /hw/src/tb
vlog -work work $lib_include $lib_vx_rtl $lib_vx_tex_unit $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(GPGPU_HOME)/hw/src/tb/testbench.sv

vsim -gui -wlf ./gpgpu.wlf work.testbench -voptargs="+acc"

run -all

exit
