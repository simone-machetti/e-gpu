// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module config_regs
(
    input logic clk_i,
    input logic rst_ni,

    obi_req_if.slave  regs_req,
    obi_rsp_if.master regs_rsp,

    output logic gpu_start_o
);

    /*
    * REGISTERS:
    *
    * - regs[0][0] : GPU start - active high (default: 0)
    * - regs[1]    : unused
    * - regs[2]    : unused
    * - regs[3]    : unused
    *
    */

    typedef enum logic [1:0] {IDLE, READ, WRITE} state_t;

    logic [31:0] curr_regs [0:3];
    logic [31:0] next_regs [0:3];

    state_t      curr_state;
    state_t      next_state;

    logic [3:0]  be;
    logic [1:0]  addr;
    logic [31:0] wdata;

    assign gpu_start_o = curr_regs[0][0];

    always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
        if (!rst_ni) begin
            for (int i=0; i<4; i++) begin
                curr_regs[i] <= 32'h00000000;
            end
        end
        else begin
            curr_regs <= next_regs;
        end
    end

    always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
        if (!rst_ni) begin
            be    <= '0;
            addr  <= '0;
            wdata <= '0;
        end
        else begin
            be    <= regs_req.be;
            addr  <= regs_req.addr[3:2];
            wdata <= regs_req.wdata;
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

        next_state      = curr_state;
        regs_req.gnt    = 1'b0;
        regs_rsp.rvalid = 1'b0;
        regs_rsp.rdata  = 32'd0;
        next_regs       = curr_regs;

        case(curr_state)

            IDLE: begin
                if (regs_req.req) begin
                    if (regs_req.we) begin
                        regs_req.gnt = 1'b1;
                        next_state   = WRITE;
                    end
                    else begin
                        regs_req.gnt = 1'b1;
                        next_state   = READ;
                    end
                end
                else begin
                    next_state = IDLE;
                end
            end

            READ: begin
                regs_rsp.rvalid = 1'b1;
                regs_rsp.rdata  = next_regs[addr];
                next_state      = IDLE;
            end

            WRITE: begin
                regs_rsp.rvalid            = 1'b1;
                if (be[0])
                    next_regs[addr][7:0]   = wdata[7:0];
                if (be[1])
                    next_regs[addr][15:8]  = wdata[15:8];
                if (be[2])
                    next_regs[addr][23:16] = wdata[23:16];
                if (be[3])
                    next_regs[addr][31:24] = wdata[31:24];
                next_state                 = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase

    end

endmodule
