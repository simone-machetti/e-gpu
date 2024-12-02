// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module l1_data_cache
(
    input logic clk_i,
    input logic rst_ni,

    VX_dcache_req_if.slave  pipeline_data_req,
    VX_dcache_rsp_if.master pipeline_data_rsp,

    VX_mem_req_if.master l2_data_cache_req,
    VX_mem_rsp_if.slave  l2_data_cache_rsp
);

    VX_cache #(
        .CACHE_ID         (0),
        .CACHE_SIZE       (`DCACHE_SIZE),
        .CACHE_LINE_SIZE  (`DCACHE_LINE_SIZE),
        .NUM_BANKS        (`DCACHE_NUM_BANKS),
        .NUM_PORTS        (`DCACHE_NUM_PORTS),
        .WORD_SIZE        (`DCACHE_WORD_SIZE),
        .NUM_REQS         (`DCACHE_NUM_REQS),
        .CREQ_SIZE        (`DCACHE_CREQ_SIZE),
        .CRSQ_SIZE        (`DCACHE_CRSQ_SIZE),
        .MSHR_SIZE        (`DCACHE_MSHR_SIZE),
        .MRSQ_SIZE        (`DCACHE_MRSQ_SIZE),
        .MREQ_SIZE        (`DCACHE_MREQ_SIZE),
        .WRITE_ENABLE     (1),
        .CORE_TAG_WIDTH   (`DCACHE_CORE_TAG_WIDTH-`SM_ENABLE),
        .CORE_TAG_ID_BITS (`DCACHE_CORE_TAG_ID_BITS-`SM_ENABLE),
        .MEM_TAG_WIDTH    (`DCACHE_MEM_TAG_WIDTH)
    ) vx_l1_data_cache_i (
        .clk              (clk_i),
        .reset            (~rst_ni),
        .core_req_valid   (pipeline_data_req.valid),
        .core_req_rw      (pipeline_data_req.rw),
        .core_req_byteen  (pipeline_data_req.byteen),
        .core_req_addr    (pipeline_data_req.addr),
        .core_req_data    (pipeline_data_req.data),
        .core_req_tag     (pipeline_data_req.tag),
        .core_req_ready   (pipeline_data_req.ready),
        .core_rsp_valid   (pipeline_data_rsp.valid),
        .core_rsp_tmask   (pipeline_data_rsp.tmask),
        .core_rsp_data    (pipeline_data_rsp.data),
        .core_rsp_tag     (pipeline_data_rsp.tag),
        .core_rsp_ready   (pipeline_data_rsp.ready),
        .mem_req_valid    (l2_data_cache_req.valid),
        .mem_req_rw       (l2_data_cache_req.rw),
        .mem_req_byteen   (l2_data_cache_req.byteen),
        .mem_req_addr     (l2_data_cache_req.addr),
        .mem_req_data     (l2_data_cache_req.data),
        .mem_req_tag      (l2_data_cache_req.tag),
        .mem_req_ready    (l2_data_cache_req.ready),
        .mem_rsp_valid    (l2_data_cache_rsp.valid),
        .mem_rsp_data     (l2_data_cache_rsp.data),
        .mem_rsp_tag      (l2_data_cache_rsp.tag),
        .mem_rsp_ready    (l2_data_cache_rsp.ready)
    );

endmodule
