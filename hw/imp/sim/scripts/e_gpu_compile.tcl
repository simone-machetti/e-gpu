# Copyright 2023 EPFL
# Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
#
# Author: Simone Machetti - simone.machetti@epfl.ch

vlib work

set lib_include       +incdir+$env(E_GPU_HOME)/hw/src/rtl
set lib_vx_rtl        +incdir+$env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl
set lib_vx_libs       +incdir+$env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs
set lib_vx_interfaces +incdir+$env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces
set lib_vx_fp_cores   +incdir+$env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/fp_cores
set lib_vx_cache      +incdir+$env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache

# /hw/src/vendor/vortex/hw/rtl/cache
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_tag_access.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_shared_mem.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_nc_bypass.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_miss_resrv.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_flush_ctrl.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_data_access.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_core_rsp_merge.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_core_req_bank_sel.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_cache.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/cache/VX_bank.sv

# /hw/src/vendor/vortex/hw/rtl/interfaces
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_wstall_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_writeback_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_warp_ctl_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_tex_rsp_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_tex_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_tex_csr_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_perf_tex_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_perf_pipeline_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_perf_memsys_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_perf_cache_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_mem_rsp_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_mem_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_lsu_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_join_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_ifetch_rsp_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_ifetch_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_icache_rsp_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_icache_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_ibuffer_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_gpu_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_gpr_rsp_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_gpr_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_fpu_to_csr_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_fpu_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_fetch_to_csr_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_decode_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_dcache_rsp_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_dcache_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_csr_req_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_commit_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_cmt_to_csr_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_branch_ctl_if.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/interfaces/VX_alu_req_if.sv

# /hw/src/vendor/vortex/hw/rtl/libs
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_stream_demux.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_stream_arbiter.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_sp_ram.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_skid_buffer.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_shift_register.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_serial_div.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_scope.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_scan.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_rr_arbiter.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_reset_relay.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_priority_encoder.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_popcount.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_pipe_register.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_pending_size.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_onehot_mux.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_onehot_encoder.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_mux.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_multiplier.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_matrix_arbiter.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_lzc.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_index_queue.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_index_buffer.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_fixed_arbiter.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_find_first.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_fifo_queue.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_fair_arbiter.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_elastic_buffer.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_dp_ram.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_divider.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_bypass_buffer.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_bits_remove.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_bits_insert.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/libs/VX_axi_adapter.sv

# /hw/src/vendor/vortex/hw/rtl
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_writeback.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_warp_sched.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_smem_arb.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_scoreboard.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_muldiv.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_mem_unit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_mem_arb.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_lsu_unit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_issue.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_ipdom_stack.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_icache_stage.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_ibuffer.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_gpu_unit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_gpr_stage.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_fetch.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_execute.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_dispatch.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_decode.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_csr_unit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_csr_data.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_commit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_cluster.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_cache_arb.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_alu_unit.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_core.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/vortex/hw/rtl/VX_pipeline.sv

# /hw/src/rtl/common
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/common/clock_gating_cell_behavioral.sv
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/common/clock_gating_cell_wrapper.sv

if {$env(SEL_MEM_HIER) == "CACHE"} {

    # /hw/src/rtl/interfaces
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/interfaces/obi_req_if.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/interfaces/obi_rsp_if.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/interfaces/vx_cache_req_if.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/interfaces/vx_cache_rsp_if.sv

    # /hw/src/rtl/common
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/common/single_port_sram_behavioral.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/common/single_port_sram_wrapper.sv

    # /hw/src/rtl/e_gpu/compute_unit
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/e_gpu/compute_unit/pipeline.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/e_gpu/compute_unit/l1_instr_cache.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/e_gpu/compute_unit/l1_data_cache.sv

    # /hw/src/rtl/e_gpu/controller_cache
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/e_gpu/controller_cache/config_regs_cache.sv

    # /hw/src/rtl/e_gpu/l2_shared_cache/bus_adapter
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/e_gpu/l2_shared_cache/bus_adapter/serializer.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/e_gpu/l2_shared_cache/bus_adapter/vx_mem_to_obi_bridge.sv

    # /hw/src/rtl/e_gpu/l2_shared_cache
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/e_gpu/l2_shared_cache/bus_adapter.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/e_gpu/l2_shared_cache/l2_cache.sv

    # /hw/src/rtl/e_gpu
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/e_gpu/compute_unit.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/e_gpu/controller_cache.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/e_gpu/l2_shared_cache.sv

} else {

    # /hw/src/rtl/interfaces
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/interfaces/obi_req_if.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/interfaces/obi_rsp_if.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/interfaces/dma_ctrl_if.sv

    # /hw/src/rtl/common
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/common/single_port_sram_behavioral.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/common/single_port_sram_wrapper.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/common/double_port_sram_behavioral.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/common/double_port_sram_wrapper.sv

    # /hw/src/rtl/controller_scratchpad
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/controller_scratchpad/controller_scratchpad.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/controller_scratchpad/controller_scratchpad_top.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/controller_scratchpad/dma.sv

    # /hw/src/rtl/mem_hier_scratchpad/include
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/mem_hier_scratchpad/include/mem_map_pkg.sv

    # /hw/src/vendor/common_cells/src
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/common_cells/src/rr_arb_tree.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/common_cells/src/cf_math_pkg.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/common_cells/src/lzc.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/common_cells/src/addr_decode.sv

    # /hw/src/vendor/crossbar/rtl/tcdm_variable_latency_interconnect
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/crossbar/rtl/tcdm_variable_latency_interconnect/addr_dec_resp_mux_varlat.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/vendor/crossbar/rtl/tcdm_variable_latency_interconnect/xbar_varlat.sv

    # /hw/src/rtl/mem_hier_scratchpad
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/mem_hier_scratchpad/vx_icache_to_obi_bridge.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/mem_hier_scratchpad/vx_dcache_to_obi_bridge.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/mem_hier_scratchpad/il_bus_interconnect.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/mem_hier_scratchpad/instr_mem.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/mem_hier_scratchpad/data_mem.sv
    vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/mem_hier_scratchpad/mem_hier_scratchpad_top.sv

}

# /hw/src/rtl/
vlog -work work $lib_include $lib_vx_rtl $lib_vx_libs $lib_vx_interfaces $lib_vx_fp_cores $lib_vx_cache $env(E_GPU_HOME)/hw/src/rtl/e_gpu.sv -define $env(SEL_MEM_HIER)
