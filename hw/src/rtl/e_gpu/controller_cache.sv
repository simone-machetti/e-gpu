// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module controller_cache
(
    input logic clk_i,
    input logic rst_ni,

    obi_req_if.slave  regs_req,
    obi_rsp_if.master regs_rsp,

    output logic clk_core_o,
    output logic rst_n_core_o
);

    logic clk_core_en;

    clock_gating_cell_wrapper clock_gating_cell_wrapper_i (
        .clk_i (clk_i),
        .en_i  (clk_core_en),
        .clk_o (clk_core_o)
    );

    config_regs_cache config_regs_cache_i (
        .clk_i         (clk_i),
        .rst_ni        (rst_ni),
        .regs_req      (regs_req),
        .regs_rsp      (regs_rsp),
        .clk_core_en_o (clk_core_en),
        .rst_n_core_o  (rst_n_core_o)
    );

endmodule
