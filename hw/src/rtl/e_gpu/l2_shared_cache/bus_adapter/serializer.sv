// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module serializer #(
    parameter ADDR_WIDTH_BIT = 32,
    parameter DATA_WIDTH_BIT = 32,
    parameter TAG_WIDTH_BIT  = 1
)(
    input logic clk_i,
    input logic rst_ni,

    VX_mem_req_if.slave  in_mem_req,
    VX_mem_rsp_if.master in_mem_rsp,

    VX_mem_req_if.master out_mem_req,
    VX_mem_rsp_if.slave  out_mem_rsp
);

    localparam WORD_SIZE_BYTE = 4;
    localparam WORD_WIDTH_BIT = 32;
    localparam DATA_SIZE_BYTE = DATA_WIDTH_BIT/8;
    localparam NUM_DATA_WORDS = DATA_SIZE_BYTE/WORD_SIZE_BYTE;

    typedef enum logic [1:0] {IDLE, SEND_OUT_REQ, WAIT_OUT_RSP, SEND_IN_RSP} state_t;

    state_t curr_state;
    state_t next_state;

    logic                      curr_in_req_rw;
    logic [DATA_SIZE_BYTE-1:0] curr_in_req_byteen;
    logic [ADDR_WIDTH_BIT-1:0] curr_in_req_addr;
    logic [DATA_WIDTH_BIT-1:0] curr_in_req_data;
    logic [TAG_WIDTH_BIT-1:0]  curr_in_req_tag;

    logic                      next_in_req_rw;
    logic [DATA_SIZE_BYTE-1:0] next_in_req_byteen;
    logic [ADDR_WIDTH_BIT-1:0] next_in_req_addr;
    logic [DATA_WIDTH_BIT-1:0] next_in_req_data;
    logic [TAG_WIDTH_BIT-1:0]  next_in_req_tag;

    logic [$clog2(NUM_DATA_WORDS)-1:0] curr_count;
    logic [$clog2(NUM_DATA_WORDS)-1:0] next_count;

    logic [DATA_WIDTH_BIT-1:0] curr_out_rsp_data;
    logic [TAG_WIDTH_BIT-1:0]  curr_out_rsp_tag;

    logic [DATA_WIDTH_BIT-1:0] next_out_rsp_data;
    logic [TAG_WIDTH_BIT-1:0]  next_out_rsp_tag;

    logic store_in_req;
    logic store_out_rsp;
    logic count;

    logic in_mem_req_ready;
    logic in_mem_rsp_valid;
    logic out_mem_req_valid;
    logic out_mem_rsp_ready;

    /*
    * Store input request
    */
    always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
        if (!rst_ni) begin
            curr_in_req_rw     <= '0;
            curr_in_req_byteen <= '0;
            curr_in_req_addr   <= '0;
            curr_in_req_data   <= '0;
            curr_in_req_tag    <= '0;
        end
        else begin
            curr_in_req_rw     <= next_in_req_rw;
            curr_in_req_byteen <= next_in_req_byteen;
            curr_in_req_addr   <= next_in_req_addr;
            curr_in_req_data   <= next_in_req_data;
            curr_in_req_tag    <= next_in_req_tag;
        end
    end

    assign next_in_req_rw     = store_in_req ? in_mem_req.rw     : curr_in_req_rw;
    assign next_in_req_byteen = store_in_req ? in_mem_req.byteen : curr_in_req_byteen;
    assign next_in_req_addr   = store_in_req ? in_mem_req.addr   : curr_in_req_addr;
    assign next_in_req_data   = store_in_req ? in_mem_req.data   : curr_in_req_data;
    assign next_in_req_tag    = store_in_req ? in_mem_req.tag    : curr_in_req_tag;

    /*
    * Counter
    */
    always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
        if (!rst_ni)
            curr_count <= '0;
        else
            curr_count <= next_count;
    end

    assign next_count = count ? curr_count+1 : curr_count;

    /*
    * Send output request
    */
    assign out_mem_req.rw     = curr_in_req_rw;
    assign out_mem_req.byteen = curr_in_req_byteen[curr_count*WORD_SIZE_BYTE +: WORD_SIZE_BYTE];
    assign out_mem_req.addr   = {curr_in_req_addr, curr_count, 2'b00};
    assign out_mem_req.data   = curr_in_req_data[curr_count*WORD_WIDTH_BIT +: WORD_WIDTH_BIT];
    assign out_mem_req.tag    = curr_in_req_tag;

    /*
    * Store output response
    */
    always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
        if (!rst_ni) begin
            curr_out_rsp_data <= '0;
            curr_out_rsp_tag  <= '0;
        end
        else begin
            curr_out_rsp_data <= next_out_rsp_data;
            curr_out_rsp_tag  <= next_out_rsp_tag;
        end
    end

    always_comb begin
        next_out_rsp_data[curr_count*WORD_WIDTH_BIT +: WORD_WIDTH_BIT] = store_out_rsp ? out_mem_rsp.data : curr_out_rsp_data[curr_count*WORD_WIDTH_BIT +: WORD_WIDTH_BIT];
    end

    assign next_out_rsp_tag = store_out_rsp ? out_mem_rsp.tag : curr_out_rsp_tag;

    /*
    * Send input response
    */
    assign in_mem_rsp.data = curr_out_rsp_data;
    assign in_mem_rsp.tag  = curr_out_rsp_tag;

    /*
    * Send ready and valid signals
    */
    assign in_mem_req.ready  = in_mem_req_ready;
    assign in_mem_rsp.valid  = in_mem_rsp_valid;
    assign out_mem_req.valid = out_mem_req_valid;
    assign out_mem_rsp.ready = out_mem_rsp_ready;

    /*
    * FSM
    */
    always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
        if (!rst_ni)
            curr_state <= IDLE;
        else
            curr_state <= next_state;
    end

    always_comb begin
        next_state        = curr_state;
        store_in_req      = 1'b0;
        in_mem_req_ready  = 1'b0;
        out_mem_req_valid = 1'b0;
        count             = 1'b0;
        store_out_rsp     = 1'b0;
        out_mem_rsp_ready = 1'b0;
        in_mem_rsp_valid  = 1'b0;
        case (curr_state)
            IDLE: begin
                if (in_mem_req.valid) begin
                    store_in_req     = 1'b1;
                    in_mem_req_ready = 1'b1;
                    next_state       = SEND_OUT_REQ;
                end
                else begin
                    next_state = IDLE;
                end
            end
            SEND_OUT_REQ: begin
                out_mem_req_valid = 1'b1;
                if (out_mem_req.ready) begin
                    if (curr_in_req_rw) begin
                        count = 1'b1;
                        if (curr_count == NUM_DATA_WORDS-1) begin
                            next_state = IDLE;
                        end
                        else begin
                            next_state = SEND_OUT_REQ;
                        end
                    end
                    else begin
                        next_state = WAIT_OUT_RSP;
                    end
                end
                else begin
                    next_state = SEND_OUT_REQ;
                end
            end
            WAIT_OUT_RSP: begin
                if (out_mem_rsp.valid) begin
                    store_out_rsp     = 1'b1;
                    out_mem_rsp_ready = 1'b1;
                    count             = 1'b1;
                    if (curr_count == NUM_DATA_WORDS-1) begin
                        next_state = SEND_IN_RSP;
                    end
                    else begin
                        next_state = SEND_OUT_REQ;
                    end
                end
                else begin
                    next_state = WAIT_OUT_RSP;
                end
            end
            SEND_IN_RSP: begin
                in_mem_rsp_valid = 1'b1;
                if (in_mem_rsp.ready) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = SEND_IN_RSP;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
