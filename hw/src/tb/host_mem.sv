// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

module host_mem #(
    parameter MEM_SIZE_WORD = 32768
)(
    input logic clk_i,
    input logic rst_ni,

    obi_req_if.slave  host_mem_req,
    obi_rsp_if.master host_mem_rsp
);

    typedef enum logic [1:0] {IDLE, READ, WRITE} state_t;

    logic [31:0] mem_array [0:MEM_SIZE_WORD-1];

    state_t      curr_state;
    state_t      next_state;

    logic [ 3:0] be;
    logic [29:0] addr;
    logic [31:0] wdata;

    always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
        if (!rst_ni) begin
            be    <= '0;
            addr  <= '0;
            wdata <= '0;
        end
        else begin
            be    <= host_mem_req.be;
            addr  <= host_mem_req.addr[31:2];
            wdata <= host_mem_req.wdata;
        end
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            curr_state <= IDLE;
        end
        else begin
            curr_state <= next_state;
        end
    end

    always_comb begin

        next_state          = curr_state;
        host_mem_req.gnt    = 1'b0;
        host_mem_rsp.rvalid = 1'b0;
        host_mem_rsp.rdata  = 32'd0;

        case(curr_state)

            IDLE: begin
                if (host_mem_req.req) begin
                    if (host_mem_req.we) begin
                        host_mem_req.gnt = 1'b1;
                        next_state       = WRITE;
                    end
                    else begin
                        host_mem_req.gnt = 1'b1;
                        next_state       = READ;
                    end
                end
                else begin
                    next_state = IDLE;
                end
            end

            READ: begin
                host_mem_rsp.rvalid = 1'b1;
                host_mem_rsp.rdata  = mem_array[addr];
                next_state          = IDLE;
            end

            WRITE: begin
                host_mem_rsp.rvalid = 1'b1;
                if (be[0]) begin
                    mem_array[addr][7:0]   = wdata[7:0];
                end
                if (be[1]) begin
                    mem_array[addr][15:8]  = wdata[15:8];
                end
                if (be[2]) begin
                    mem_array[addr][23:16] = wdata[23:16];
                end
                if (be[3]) begin
                    mem_array[addr][31:24] = wdata[31:24];
                end
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase

    end

endmodule
