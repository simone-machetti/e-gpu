// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module double_port_sram_behavioral #(
    parameter MEM_SIZE_BYTE = 32768
)(
    input logic clk_i,
    input logic rst_ni,

    obi_req_if.slave  req_0,
    obi_rsp_if.master rsp_0,

    obi_req_if.slave  req_1,
    obi_rsp_if.master rsp_1
);

    localparam MEM_SIZE_WORD = MEM_SIZE_BYTE*4;

    logic [31:0] mem_array [0:MEM_SIZE_WORD-1];

    typedef enum logic [1:0] {IDLE, READ, WRITE} state_t;

    state_t curr_state_0;
    state_t next_state_0;

    logic [3:0]                       be_0;
    logic [$clog2(MEM_SIZE_BYTE)-3:0] addr_0;
    logic [31:0]                      wdata_0;

    state_t curr_state_1;
    state_t next_state_1;

    logic [3:0]                       be_1;
    logic [$clog2(MEM_SIZE_BYTE)-3:0] addr_1;
    logic [31:0]                      wdata_1;

    /*
    * Port 0: read only
    */
    always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
        if (!rst_ni) begin
            be_0    <= '0;
            addr_0  <= '0;
            wdata_0 <= '0;
        end
        else begin
            be_0    <= req_0.be;
            addr_0  <= req_0.addr[$clog2(MEM_SIZE_BYTE)-1:2];
            wdata_0 <= req_0.wdata;
        end
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            curr_state_0 <= IDLE;
        end
        else begin
            curr_state_0 <= next_state_0;
        end
    end

    always_comb begin
        next_state_0 = curr_state_0;
        req_0.gnt    = 1'b0;
        rsp_0.rvalid = 1'b0;
        rsp_0.rdata  = 32'd0;
        case(curr_state_0)
            IDLE: begin
                if (req_0.req) begin
                    if (req_0.we) begin
                        req_0.gnt    = 1'b1;
                        next_state_0 = WRITE;
                    end
                    else begin
                        req_0.gnt    = 1'b1;
                        next_state_0 = READ;
                    end
                end
                else begin
                    next_state_0 = IDLE;
                end
            end
            READ: begin
                rsp_0.rvalid = 1'b1;
                rsp_0.rdata  = mem_array[addr_0];
                next_state_0 = IDLE;
            end
            WRITE: begin
                rsp_0.rvalid = 1'b1;
                next_state_0 = IDLE;
            end
            default: begin
                next_state_0 = IDLE;
            end
        endcase
    end

    /*
    * Port 1: read and write
    */
    always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
        if (!rst_ni) begin
            be_1    <= '0;
            addr_1  <= '0;
            wdata_1 <= '0;
        end
        else begin
            be_1    <= req_1.be;
            addr_1  <= req_1.addr[$clog2(MEM_SIZE_BYTE)-1:2];
            wdata_1 <= req_1.wdata;
        end
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            curr_state_1 <= IDLE;
        end
        else begin
            curr_state_1 <= next_state_1;
        end
    end

    always_comb begin
        next_state_1 = curr_state_1;
        req_1.gnt    = 1'b0;
        rsp_1.rvalid = 1'b0;
        rsp_1.rdata  = 32'd0;
        case(curr_state_1)
            IDLE: begin
                if (req_1.req) begin
                    if (req_1.we) begin
                        req_1.gnt    = 1'b1;
                        next_state_1 = WRITE;
                    end
                    else begin
                        req_1.gnt    = 1'b1;
                        next_state_1 = READ;
                    end
                end
                else begin
                    next_state_1 = IDLE;
                end
            end
            READ: begin
                rsp_1.rvalid = 1'b1;
                rsp_1.rdata  = mem_array[addr_1];
                next_state_1 = IDLE;
            end
            WRITE: begin
                rsp_1.rvalid                 = 1'b1;
                if (be_1[0])
                    mem_array[addr_1][7:0]   = wdata_1[7:0];
                if (be_1[1])
                    mem_array[addr_1][15:8]  = wdata_1[15:8];
                if (be_1[2])
                    mem_array[addr_1][23:16] = wdata_1[23:16];
                if (be_1[3])
                    mem_array[addr_1][31:24] = wdata_1[31:24];
                next_state_1                 = IDLE;
            end
            default: begin
                next_state_1 = IDLE;
            end
        endcase
    end

endmodule
