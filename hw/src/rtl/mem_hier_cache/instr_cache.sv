// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "VX_define.vh"

module instr_cache
(
    input logic clk_i,
    input logic rst_ni,

    VX_icache_req_if.slave  core_req,
    VX_icache_rsp_if.master core_rsp,

    VX_mem_req_if.master mem_req,
    VX_mem_rsp_if.slave  mem_rsp
);

    VX_cache #(
        .CACHE_ID         (0),
        .CACHE_SIZE       (`ICACHE_SIZE),
        .CACHE_LINE_SIZE  (`ICACHE_LINE_SIZE),
        .NUM_BANKS        (1),
        .WORD_SIZE        (`ICACHE_WORD_SIZE),
        .NUM_REQS         (1),
        .CREQ_SIZE        (`ICACHE_CREQ_SIZE),
        .CRSQ_SIZE        (`ICACHE_CRSQ_SIZE),
        .MSHR_SIZE        (`ICACHE_MSHR_SIZE),
        .MRSQ_SIZE        (`ICACHE_MRSQ_SIZE),
        .MREQ_SIZE        (`ICACHE_MREQ_SIZE),
        .WRITE_ENABLE     (0),
        .CORE_TAG_WIDTH   (`ICACHE_CORE_TAG_WIDTH),
        .CORE_TAG_ID_BITS (`ICACHE_CORE_TAG_ID_BITS),
        .MEM_TAG_WIDTH    (`ICACHE_MEM_TAG_WIDTH)
    ) instr_cache_i (
        .clk              (clk_i),
        .reset            (~rst_ni),
        .core_req_valid   (core_req.valid),
        .core_req_rw      ('0),
        .core_req_byteen  ('0),
        .core_req_addr    (core_req.addr),
        .core_req_data    ('0),
        .core_req_tag     (core_req.tag),
        .core_req_ready   (core_req.ready),
        .core_rsp_valid   (core_rsp.valid),
        .core_rsp_tmask   (),
        .core_rsp_data    (core_rsp.data),
        .core_rsp_tag     (core_rsp.tag),
        .core_rsp_ready   (core_rsp.ready),
        .mem_req_valid    (mem_req.valid),
        .mem_req_rw       (mem_req.rw),
        .mem_req_byteen   (mem_req.byteen),
        .mem_req_addr     (mem_req.addr),
        .mem_req_data     (mem_req.data),
        .mem_req_tag      (mem_req.tag),
        .mem_req_ready    (mem_req.ready),
        .mem_rsp_valid    (mem_rsp.valid),
        .mem_rsp_data     (mem_rsp.data),
        .mem_rsp_tag      (mem_rsp.tag),
        .mem_rsp_ready    (mem_rsp.ready)
    );

endmodule
