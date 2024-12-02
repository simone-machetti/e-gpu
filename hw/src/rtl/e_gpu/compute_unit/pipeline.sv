// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module pipeline #(
    parameter COMPUTE_UNIT_ID = 0
)(
    input logic clk_i,
    input logic rst_ni,

    VX_icache_req_if.master l1_instr_cache_req,
    VX_icache_rsp_if.slave  l1_instr_cache_rsp,

    VX_dcache_req_if.master l1_data_cache_req,
    VX_dcache_rsp_if.slave  l1_data_cache_rsp
);

    VX_pipeline #(
        .CORE_ID(COMPUTE_UNIT_ID)
    ) vx_pipeline_i (
        .clk               (clk_i),
        .reset             (~rst_ni),
        .icache_req_valid  (l1_instr_cache_req.valid),
        .icache_req_addr   (l1_instr_cache_req.addr),
        .icache_req_tag    (l1_instr_cache_req.tag),
        .icache_req_ready  (l1_instr_cache_req.ready),
        .icache_rsp_valid  (l1_instr_cache_rsp.valid),
        .icache_rsp_data   (l1_instr_cache_rsp.data),
        .icache_rsp_tag    (l1_instr_cache_rsp.tag),
        .icache_rsp_ready  (l1_instr_cache_rsp.ready),
        .dcache_req_valid  (l1_data_cache_req.valid),
        .dcache_req_rw     (l1_data_cache_req.rw),
        .dcache_req_byteen (l1_data_cache_req.byteen),
        .dcache_req_addr   (l1_data_cache_req.addr),
        .dcache_req_data   (l1_data_cache_req.data),
        .dcache_req_tag    (l1_data_cache_req.tag),
        .dcache_req_ready  (l1_data_cache_req.ready),
        .dcache_rsp_valid  (l1_data_cache_rsp.valid),
        .dcache_rsp_tmask  (l1_data_cache_rsp.tmask),
        .dcache_rsp_data   (l1_data_cache_rsp.data),
        .dcache_rsp_tag    (l1_data_cache_rsp.tag),
        .dcache_rsp_ready  (l1_data_cache_rsp.ready),
        .busy              ()
    );

endmodule
