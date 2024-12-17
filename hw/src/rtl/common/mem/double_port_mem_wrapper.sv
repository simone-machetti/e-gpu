// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module double_port_mem_wrapper #(
    parameter DATAW   = 1,
    parameter SIZE    = 1,
    parameter OUT_REG = 0,
    parameter ADDRW   = $clog2(SIZE)
)(
    input  logic             clk_i,
    input  logic             rst_ni,
    input  logic             wren_i,
    input  logic [ADDRW-1:0] waddr_i,
    input  logic [DATAW-1:0] wdata_i,
    input  logic [ADDRW-1:0] raddr_i,
    output logic [DATAW-1:0] rdata_o
);

    double_port_mem_behavioral #(
        .DATAW   (DATAW),
        .SIZE    (SIZE),
        .OUT_REG (OUT_REG)
    ) double_port_mem_behavioral_i (
        .clk_i   (clk_i),
        .rst_ni  (rst_ni),
        .wren_i  (wren_i),
        .waddr_i (waddr_i),
        .wdata_i (wdata_i),
        .raddr_i (raddr_i),
        .rdata_o (rdata_o)
    );

endmodule
