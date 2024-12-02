// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module compute_unit #(
    parameter COMPUTE_UNIT_ID = 0
)(
    input logic clk_i,
    input logic rst_ni,

    VX_mem_req_if.master l2_instr_cache_req,
    VX_mem_rsp_if.slave  l2_instr_cache_rsp,

    VX_mem_req_if.master l2_data_cache_req,
    VX_mem_rsp_if.slave  l2_data_cache_rsp
);

    VX_icache_req_if #(
        .WORD_SIZE (`ICACHE_WORD_SIZE),
        .TAG_WIDTH (`ICACHE_CORE_TAG_WIDTH)
    ) l1_instr_cache_req();

    VX_icache_rsp_if #(
        .WORD_SIZE (`ICACHE_WORD_SIZE),
        .TAG_WIDTH (`ICACHE_CORE_TAG_WIDTH)
    ) l1_instr_cache_rsp();

    VX_dcache_req_if #(
        .NUM_REQS  (`DCACHE_NUM_REQS),
        .WORD_SIZE (`DCACHE_WORD_SIZE),
        .TAG_WIDTH (`DCACHE_CORE_TAG_WIDTH)
    ) l1_data_cache_req();

    VX_dcache_rsp_if #(
        .NUM_REQS  (`DCACHE_NUM_REQS),
        .WORD_SIZE (`DCACHE_WORD_SIZE),
        .TAG_WIDTH (`DCACHE_CORE_TAG_WIDTH)
    ) l1_data_cache_rsp();

    pipeline #(
        .COMPUTE_UNIT_ID    (COMPUTE_UNIT_ID)
    ) pipeline_i (
        .clk_i              (clk_i),
        .rst_ni             (rst_ni),
        .l1_instr_cache_req (l1_instr_cache_req),
        .l1_instr_cache_rsp (l1_instr_cache_rsp),
        .l1_data_cache_req  (l1_data_cache_req),
        .l1_data_cache_rsp  (l1_data_cache_rsp)
    );

    l1_instr_cache l1_instr_cache_i (
        .clk_i              (clk_i),
        .rst_ni             (rst_ni),
        .pipeline_instr_req (l1_instr_cache_req),
        .pipeline_instr_rsp (l1_instr_cache_rsp),
        .l2_instr_cache_req (l2_instr_cache_req),
        .l2_instr_cache_rsp (l2_instr_cache_rsp)
    );

    l1_data_cache l1_data_cache_i (
        .clk_i             (clk_i),
        .rst_ni            (rst_ni),
        .pipeline_data_req (l1_data_cache_req),
        .pipeline_data_rsp (l1_data_cache_rsp),
        .l2_data_cache_req (l2_data_cache_req),
        .l2_data_cache_rsp (l2_data_cache_rsp)
    );

endmodule
