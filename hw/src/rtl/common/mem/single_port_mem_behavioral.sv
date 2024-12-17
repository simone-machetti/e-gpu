// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module single_port_mem_behavioral #(
    parameter DATAW   = 1,
    parameter SIZE    = 1,
    parameter BYTEENW = 1,
    parameter ADDRW   = $clog2(SIZE)
)(
    input  logic               clk_i,
    input  logic               rst_ni,
    input  logic [ADDRW-1:0]   addr_i,
    input  logic [BYTEENW-1:0] wren_i,
    input  logic [DATAW-1:0]   wdata_i,
    output logic [DATAW-1:0]   rdata_o
);

    if (BYTEENW > 1) begin

        logic [BYTEENW-1:0][7:0] curr_ram [SIZE-1:0];
        logic [BYTEENW-1:0][7:0] next_ram [SIZE-1:0];

        logic [DATAW-1:0] curr_rdata;
        logic [DATAW-1:0] next_rdata;

        always_ff @(posedge(clk_i)) begin
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
            for (int i=0; i<BYTEENW; i++) begin
                if (wren_i[i])
                    next_ram[addr_i][i] = wdata_i[i*8 +: 8];
            end
        end

        assign next_rdata = curr_ram[addr_i];

        always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
            if (!rst_ni) begin
                curr_rdata <= 0;
            end
            else begin
                curr_rdata <= next_rdata;
            end
        end

        assign rdata_o = curr_rdata;

    end else begin

        logic [DATAW-1:0] curr_ram [SIZE-1:0];
        logic [DATAW-1:0] next_ram [SIZE-1:0];

        logic [DATAW-1:0] curr_rdata;
        logic [DATAW-1:0] next_rdata;

        always_ff @(posedge(clk_i)) begin
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
                next_ram[addr_i] = wdata_i;
        end

        assign next_rdata = curr_ram[addr_i];

        always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
            if (!rst_ni) begin
                curr_rdata <= 0;
            end
            else begin
                curr_rdata <= next_rdata;
            end
        end

        assign rdata_o = curr_rdata;

    end

endmodule
