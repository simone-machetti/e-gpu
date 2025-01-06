// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module triple_port_mem_behavioral #(
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

    input  logic [ADDRW-1:0] raddr_1_i,
    output logic [DATAW-1:0] rdata_1_o,

    input  logic [ADDRW-1:0] raddr_2_i,
    output logic [DATAW-1:0] rdata_2_o
);

    if (OUT_REG) begin

        logic [DATAW-1:0] curr_rdata_1;
        logic [DATAW-1:0] next_rdata_1;

        logic [DATAW-1:0] curr_rdata_2;
        logic [DATAW-1:0] next_rdata_2;

        logic [DATAW-1:0] curr_ram [SIZE-1:0];
        logic [DATAW-1:0] next_ram [SIZE-1:0];

        always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
            if (!rst_ni) begin
                for (int i=0; i<SIZE; i++) begin
                    curr_ram[i] <= 0;
                end
            end
            else begin
                curr_ram <= next_ram;
            end
        end

        always_comb begin
            next_ram = curr_ram;
            if (wren_i)
                next_ram[waddr_i] = wdata_i;
        end

        assign next_rdata_1 = curr_ram[raddr_1_i];
        assign next_rdata_2 = curr_ram[raddr_2_i];

        always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
            if (!rst_ni) begin
                curr_rdata_1 <= 0;
                curr_rdata_2 <= 0;
            end
            else begin
                curr_rdata_1 <= next_rdata_1;
                curr_rdata_2 <= next_rdata_2;
            end
        end

        assign rdata_1_o = curr_rdata_1;
        assign rdata_2_o = curr_rdata_2;

    end else begin

        logic [DATAW-1:0] curr_ram [SIZE-1:0];
        logic [DATAW-1:0] next_ram [SIZE-1:0];

        always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
            if (!rst_ni) begin
                for (int i=0; i<SIZE; i++) begin
                    curr_ram[i] <= 0;
                end
            end
            else begin
                curr_ram <= next_ram;
            end
        end

        always_comb begin
            next_ram = curr_ram;
            if (wren_i)
                next_ram[waddr_i] = wdata_i;
        end

        assign rdata_1_o = curr_ram[raddr_1_i];
        assign rdata_2_o = curr_ram[raddr_2_i];

    end

endmodule
