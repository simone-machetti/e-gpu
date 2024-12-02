// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module bus_adapter
(
    input logic clk_i,
    input logic rst_ni,

    VX_mem_req_if.slave  serial_req,
    VX_mem_rsp_if.master serial_rsp,

    obi_req_if.master host_req,
    obi_rsp_if.slave  host_rsp
);

    localparam WORD_WIDTH_BIT = 32;
    localparam ADDR_WIDTH_BIT = 32;

    VX_mem_req_if #(
        .DATA_WIDTH (WORD_WIDTH_BIT),
        .ADDR_WIDTH (ADDR_WIDTH_BIT),
        .TAG_WIDTH  (`L2_MEM_TAG_WIDTH)
    ) bridge_req();

    VX_mem_rsp_if #(
        .DATA_WIDTH (WORD_WIDTH_BIT),
        .TAG_WIDTH  (`L2_MEM_TAG_WIDTH)
    ) bridge_rsp();

    serializer #(
        .ADDR_WIDTH_BIT (`L2_MEM_ADDR_WIDTH),
        .DATA_WIDTH_BIT (`L2_MEM_DATA_WIDTH),
        .TAG_WIDTH_BIT  (`L2_MEM_TAG_WIDTH)
    ) instr_serializer_i (
        .clk_i          (clk_i),
        .rst_ni         (rst_ni),
        .in_mem_req     (serial_req),
        .in_mem_rsp     (serial_rsp),
        .out_mem_req    (bridge_req),
        .out_mem_rsp    (bridge_rsp)
    );

    vx_mem_to_obi_bridge #(
        .TAG_WIDTH_BIT (`L2_MEM_TAG_WIDTH)
    ) instr_vx_mem_to_obi_bridge_i (
        .clk_i         (clk_i),
        .rst_ni        (rst_ni),
        .vx_mem_req    (bridge_req),
        .vx_mem_rsp    (bridge_rsp),
        .obi_req       (host_req),
        .obi_rsp       (host_rsp)
    );

endmodule
