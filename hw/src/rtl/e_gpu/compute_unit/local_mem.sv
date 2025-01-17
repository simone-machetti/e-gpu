// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module local_mem
    import mem_map_pkg::*;
#(
    parameter NUM_REQS = 4
)(
    input logic clk_i,
    input logic rst_ni,

    VX_dcache_req_if.slave  data_req,
    VX_dcache_rsp_if.master data_rsp
);

    obi_req_if crossbar_data_req[NUM_REQS]();
    obi_rsp_if crossbar_data_rsp[NUM_REQS]();

    obi_req_if mem_banks_req[NUM_REQS]();
    obi_rsp_if mem_banks_rsp[NUM_REQS]();

    vx_dcache_to_obi #(
        .NUM_REQS      (NUM_REQS),
        .TAG_WIDTH_BIT (`DCACHE_CORE_TAG_WIDTH)
    ) vx_dcache_to_obi_i (
        .clk_i         (clk_i),
        .rst_ni        (rst_ni),
        .vx_req        (data_req),
        .vx_rsp        (data_rsp),
        .obi_req       (crossbar_data_req),
        .obi_rsp       (crossbar_data_rsp)
    );

    interleaved_crossbar #(
        .NUM_MASTER     (NUM_REQS),
        .NUM_SLAVE      (NUM_REQS),
        .IL_ADDR_OFFSET (mem_map_pkg::LOCAL_MEM_START_ADDRESS),
        .IL_ADDR_SIZE   (mem_map_pkg::LOCAL_MEM_END_ADDRESS-mem_map_pkg::LOCAL_MEM_START_ADDRESS)
    ) interleaved_crossbar_i (
        .clk_i          (clk_i),
        .rst_ni         (rst_ni),
        .addr_map_i     (mem_map_pkg::LOCAL_MEM_RULES),
        .default_idx_i  ('0),
        .master_req     (crossbar_data_req),
        .master_rsp     (crossbar_data_rsp),
        .slave_req      (mem_banks_req),
        .slave_rsp      (mem_banks_rsp)
    );

    mem_banks #(
        .SIZE_BYTE (`LOCAL_MEM_SIZE),
        .NUM_BANKS (NUM_REQS)
    ) mem_banks_i (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .mem_req   (mem_banks_req),
        .mem_rsp   (mem_banks_rsp)
    );

endmodule
