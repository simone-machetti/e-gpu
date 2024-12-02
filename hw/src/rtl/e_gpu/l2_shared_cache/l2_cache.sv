// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module l2_cache
(
    input logic clk_i,
    input logic rst_ni,

    VX_cache_req_if.slave  l2_cache_req,
    VX_cache_rsp_if.master l2_cache_rsp,

    VX_mem_req_if.master bus_adapter_req,
    VX_mem_rsp_if.slave  bus_adapter_rsp
);

    VX_cache #(
        .CACHE_ID         (0),
        .CACHE_SIZE       (`L2_CACHE_SIZE),
        .CACHE_LINE_SIZE  (`L2_CACHE_LINE_SIZE),
        .NUM_BANKS        (`L2_NUM_BANKS),
        .NUM_PORTS        (`L2_NUM_PORTS),
        .WORD_SIZE        (`L2_WORD_SIZE),
        .NUM_REQS         (`L2_NUM_REQS),
        .CREQ_SIZE        (`L2_CREQ_SIZE),
        .CRSQ_SIZE        (`L2_CRSQ_SIZE),
        .MSHR_SIZE        (`L2_MSHR_SIZE),
        .MRSQ_SIZE        (`L2_MRSQ_SIZE),
        .MREQ_SIZE        (`L2_MREQ_SIZE),
        .WRITE_ENABLE     (1),
        .CORE_TAG_WIDTH   (`DCACHE_MEM_TAG_WIDTH),
        .CORE_TAG_ID_BITS (0),
        .MEM_TAG_WIDTH    (`L2_MEM_TAG_WIDTH)
    ) vx_l2_shared_cache_i (
        .clk              (clk_i),
        .reset            (~rst_ni),
        .core_req_valid   (l2_cache_req.valid),
        .core_req_rw      (l2_cache_req.rw),
        .core_req_byteen  (l2_cache_req.byteen),
        .core_req_addr    (l2_cache_req.addr),
        .core_req_data    (l2_cache_req.data),
        .core_req_tag     (l2_cache_req.tag),
        .core_req_ready   (l2_cache_req.ready),
        .core_rsp_valid   (l2_cache_rsp.valid),
        .core_rsp_tmask   (),
        .core_rsp_data    (l2_cache_rsp.data),
        .core_rsp_tag     (l2_cache_rsp.tag),
        .core_rsp_ready   (l2_cache_rsp.ready),
        .mem_req_valid    (bus_adapter_req.valid),
        .mem_req_rw       (bus_adapter_req.rw),
        .mem_req_byteen   (bus_adapter_req.byteen),
        .mem_req_addr     (bus_adapter_req.addr),
        .mem_req_data     (bus_adapter_req.data),
        .mem_req_tag      (bus_adapter_req.tag),
        .mem_req_ready    (bus_adapter_req.ready),
        .mem_rsp_valid    (bus_adapter_rsp.valid),
        .mem_rsp_data     (bus_adapter_rsp.data),
        .mem_rsp_tag      (bus_adapter_rsp.tag),
        .mem_rsp_ready    (bus_adapter_rsp.ready)
    );

endmodule
