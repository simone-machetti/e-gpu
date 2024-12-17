// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module clock_gating_cell_behavioral
(
    input  logic clk_i,
    input  logic en_i,
    input  logic scan_cg_en_i,
    output logic clk_o
);

    logic clk_en;

    always_latch begin
        if (clk_i == 1'b0) begin
            clk_en <= en_i | scan_cg_en_i;
        end
    end

    assign clk_o = clk_i & clk_en;

endmodule
