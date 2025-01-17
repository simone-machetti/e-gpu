// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module mem_banks #(
    parameter SIZE_BYTE = 1024,
    parameter NUM_BANKS = 4
)(
    input logic clk_i,
    input logic rst_ni,

    obi_req_if.slave  mem_req[NUM_BANKS],
    obi_rsp_if.master mem_rsp[NUM_BANKS]
);

    localparam WORD_BIT       = 32;
    localparam WORD_BYTE      = WORD_BIT / 8;
    localparam WORD_ADDR      = $clog2(WORD_BYTE);
    localparam BANK_NUM_WORDS = (SIZE_BYTE / NUM_BANKS) / WORD_BYTE;
    localparam BANK_ADDR      = $clog2(BANK_NUM_WORDS);

    typedef enum logic {IDLE, RVALID} state_t;

    state_t               curr_state[NUM_BANKS];
    state_t               next_state[NUM_BANKS];

    logic [WORD_BYTE-1:0] be[NUM_BANKS];
    logic [BANK_ADDR-1:0] addr[NUM_BANKS];
    logic [ WORD_BIT-1:0] wdata[NUM_BANKS];

    generate

        for (genvar b = 0; b < NUM_BANKS; b++) begin : gen_local_mem_bank

            always_comb begin
                if (!mem_req[b].req) begin
                    be[b]    = '0;
                    addr[b]  = '0;
                    wdata[b] = '0;
                end
                else begin
                    be[b]    = mem_req[b].be & {WORD_BYTE{mem_req[b].we}};
                    addr[b]  = mem_req[b].addr[(WORD_ADDR+BANK_ADDR)-1:WORD_ADDR];
                    wdata[b] = mem_req[b].wdata;
                end
            end

            always_ff @(posedge clk_i or negedge rst_ni) begin
                if (!rst_ni) begin
                    curr_state[b] <= IDLE;
                end
                else begin
                    curr_state[b] <= next_state[b];
                end
            end

            always_comb begin

                next_state[b]     = curr_state[b];
                mem_req[b].gnt    = 1'b0;
                mem_rsp[b].rvalid = 1'b0;

                case(curr_state[b])

                    IDLE: begin
                        if (mem_req[b].req) begin
                            mem_req[b].gnt = 1'b1;
                            next_state[b]  = RVALID;
                        end
                        else begin
                            next_state[b] = IDLE;
                        end
                    end

                    RVALID: begin
                        mem_rsp[b].rvalid = 1'b1;
                        next_state[b]     = IDLE;
                    end

                    default: begin
                        next_state[b] = IDLE;
                    end

                endcase

            end

            single_port_mem_wrapper #(
                .DATAW   (WORD_BIT),
                .SIZE    (BANK_NUM_WORDS),
                .BYTEENW (WORD_BYTE)
            ) data_store_i (
                .clk_i   (clk_i),
                .rst_ni  (rst_ni),
                .addr_i  (addr[b]),
                .wren_i  (be[b]),
                .wdata_i (wdata[b]),
                .rdata_o (mem_rsp[b].rdata)
            );

        end

    endgenerate

endmodule
