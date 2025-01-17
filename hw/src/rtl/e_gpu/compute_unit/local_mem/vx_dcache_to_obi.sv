// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module vx_dcache_to_obi #(
    parameter NUM_REQS      = 4,
    parameter TAG_WIDTH_BIT = 1
)(
    input logic clk_i,
    input logic rst_ni,

    VX_dcache_req_if.slave  vx_req,
    VX_dcache_rsp_if.master vx_rsp,

    obi_req_if.master obi_req [NUM_REQS],
    obi_rsp_if.slave  obi_rsp [NUM_REQS]
);

    typedef enum logic [1:0] {REQ_IDLE, OBI_SEND_REQ,  OBI_WAIT_RSP,  SEND_DONE_OBI} req_state_t;
    typedef enum logic [1:0] {RSP_IDLE, WAIT_DONE_OBI, VX_SEND_RSP                 } rsp_state_t;

    req_state_t              [NUM_REQS-1:0] req_curr_state;
    req_state_t              [NUM_REQS-1:0] req_next_state;

    rsp_state_t                             rsp_curr_state;
    rsp_state_t                             rsp_next_state;

    logic               [     NUM_REQS-1:0] curr_vx_valid;
    logic               [     NUM_REQS-1:0] curr_vx_rw;
    logic [NUM_REQS-1:0][              3:0] curr_vx_byteen;
    logic [NUM_REQS-1:0][             31:0] curr_vx_addr;
    logic [NUM_REQS-1:0][             31:0] curr_vx_data;
    logic [NUM_REQS-1:0][TAG_WIDTH_BIT-1:0] curr_vx_tag;

    logic [NUM_REQS-1:0][     NUM_REQS-1:0] next_vx_valid;
    logic [NUM_REQS-1:0][     NUM_REQS-1:0] next_vx_rw;
    logic [NUM_REQS-1:0][              3:0] next_vx_byteen;
    logic [NUM_REQS-1:0][             31:0] next_vx_addr;
    logic [NUM_REQS-1:0][             31:0] next_vx_data;
    logic [NUM_REQS-1:0][TAG_WIDTH_BIT-1:0] next_vx_tag;

    logic [NUM_REQS-1:0][             31:0] curr_obi_rdata;
    logic [NUM_REQS-1:0][             31:0] next_obi_rdata;

    logic               [     NUM_REQS-1:0] store_vx;
    logic               [     NUM_REQS-1:0] store_obi;

    logic                                   start;
    logic               [     NUM_REQS-1:0] done_obi;
    logic                                   done_all;
    logic                                   done_all_tmp;

    VX_dcache_req_if #(
        .NUM_REQS  (`DCACHE_NUM_REQS),
        .WORD_SIZE (`DCACHE_WORD_SIZE),
        .TAG_WIDTH (`DCACHE_CORE_TAG_WIDTH)
    ) vx_tmp_req();

    VX_dcache_rsp_if #(
        .NUM_REQS  (`DCACHE_NUM_REQS),
        .WORD_SIZE (`DCACHE_WORD_SIZE),
        .TAG_WIDTH (`DCACHE_CORE_TAG_WIDTH)
    ) vx_tmp_rsp();

    /*
    * Input VX request and response assignments
    */
    assign vx_rsp.valid      = vx_tmp_rsp.valid;
    assign vx_rsp.tmask      = vx_tmp_rsp.tmask;
    assign vx_rsp.data       = vx_tmp_rsp.data;
    assign vx_rsp.tag        = vx_tmp_rsp.tag;

    assign vx_tmp_rsp.ready  = vx_rsp.ready;

    assign vx_tmp_req.valid  = vx_req.valid;
    assign vx_tmp_req.rw     = vx_req.rw;
    assign vx_tmp_req.byteen = vx_req.byteen;
    assign vx_tmp_req.addr   = vx_req.addr;
    assign vx_tmp_req.data   = vx_req.data;
    assign vx_tmp_req.tag    = vx_req.tag;

    assign vx_req.ready      = vx_tmp_req.ready;

    /*
    * Store input VX requests
    */
    generate

        for (genvar req = 0; req < NUM_REQS; req++) begin : gen_store_input_vx

            always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
                if (!rst_ni) begin
                    curr_vx_valid[req]  <= '0;
                    curr_vx_rw[req]     <= '0;
                    curr_vx_byteen[req] <= '0;
                    curr_vx_addr[req]   <= '0;
                    curr_vx_data[req]   <= '0;
                    curr_vx_tag[req]    <= '0;
                end
                else begin
                    curr_vx_valid[req]  <= next_vx_valid[req];
                    curr_vx_rw[req]     <= next_vx_rw[req];
                    curr_vx_byteen[req] <= next_vx_byteen[req];
                    curr_vx_addr[req]   <= next_vx_addr[req];
                    curr_vx_data[req]   <= next_vx_data[req];
                    curr_vx_tag[req]    <= next_vx_tag[req];
                end
            end

            assign next_vx_valid[req]  = store_vx[req] ? vx_tmp_req.valid[req]       : curr_vx_valid[req];
            assign next_vx_rw[req]     = store_vx[req] ? vx_tmp_req.rw[req]          : curr_vx_rw[req];
            assign next_vx_byteen[req] = store_vx[req] ? vx_tmp_req.byteen[req]      : curr_vx_byteen[req];
            assign next_vx_addr[req]   = store_vx[req] ? (vx_tmp_req.addr[req] << 2) : curr_vx_addr[req];
            assign next_vx_data[req]   = store_vx[req] ? vx_tmp_req.data[req]        : curr_vx_data[req];
            assign next_vx_tag[req]    = store_vx[req] ? vx_tmp_req.tag[req]         : curr_vx_tag[req];

            assign obi_req[req].we     = curr_vx_rw[req];
            assign obi_req[req].be     = curr_vx_byteen[req];
            assign obi_req[req].addr   = curr_vx_addr[req];
            assign obi_req[req].wdata  = curr_vx_data[req];

            assign vx_tmp_rsp.tmask[req] = curr_vx_valid[req];

        end

    endgenerate

    assign vx_tmp_rsp.tag = curr_vx_tag[0];

    /*
    * Store input OBI response
    */
    generate

        for (genvar req = 0; req < NUM_REQS; req++) begin : gen_store_input_obi

            always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
                if (!rst_ni) begin
                    curr_obi_rdata[req] <= '0;
                end
                else begin
                    curr_obi_rdata[req] <= next_obi_rdata[req];
                end
            end

            assign next_obi_rdata[req] = store_obi[req] ? obi_rsp[req].rdata : curr_obi_rdata[req];

            assign vx_tmp_rsp.data[req] = curr_obi_rdata[req];

        end

    endgenerate

    /*
    / FSM to control the Dcache requests
    */
    generate

        for (genvar req = 0; req < NUM_REQS; req++) begin: gen_fsm_transaction

            always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
                if (!rst_ni) begin
                    req_curr_state[req] <= REQ_IDLE;
                end
                else begin
                    req_curr_state[req] <= req_next_state[req];
                end
            end

            always_comb begin

                req_next_state[req]   = req_curr_state[req];
                store_vx[req]         = 1'b0;
                vx_tmp_req.ready[req] = 1'b0;
                obi_req[req].req      = 1'b0;
                store_obi[req]        = 1'b0;
                done_obi[req]         = 1'b0;

                case (req_curr_state[req])

                    REQ_IDLE: begin
                        if (start & vx_tmp_req.valid[req]) begin
                            store_vx[req]         = 1'b1;
                            vx_tmp_req.ready[req] = 1'b1;
                            req_next_state[req]   = OBI_SEND_REQ;
                        end
                        else begin
                            req_next_state[req] = REQ_IDLE;
                        end
                    end

                    OBI_SEND_REQ: begin
                        obi_req[req].req = 1'b1;
                        if (obi_req[req].gnt) begin
                            req_next_state[req] = OBI_WAIT_RSP;
                        end
                        else begin
                            req_next_state[req] = OBI_SEND_REQ;
                        end
                    end

                    OBI_WAIT_RSP: begin
                        if (obi_rsp[req].rvalid) begin
                            store_obi[req]      = 1'b1;
                            req_next_state[req] = SEND_DONE_OBI;
                        end
                        else begin
                            req_next_state[req] = OBI_WAIT_RSP;
                        end
                    end

                    SEND_DONE_OBI: begin
                        done_obi[req] = 1'b1;
                        if (done_all_tmp) begin
                            req_next_state[req] = REQ_IDLE;
                        end
                        else begin
                            req_next_state[req] = SEND_DONE_OBI;
                        end
                    end

                    default: begin
                        req_next_state[req] = REQ_IDLE;
                    end

                endcase

            end

        end

    endgenerate

    /*
    / FSM to control the Dcache response
    */
    always_ff @(posedge(clk_i) or negedge(rst_ni)) begin
        if (!rst_ni) begin
            rsp_curr_state <= RSP_IDLE;
        end
        else begin
            rsp_curr_state <= rsp_next_state;
        end
    end

    always_comb begin

        rsp_next_state   = rsp_curr_state;
        start            = 1'b0;
        vx_tmp_rsp.valid = 1'b0;
        done_all         = 1'b0;

        case (rsp_curr_state)

            RSP_IDLE: begin
                if (|vx_tmp_req.valid) begin
                    start          = 1'b1;
                    rsp_next_state = WAIT_DONE_OBI;
                end
                else begin
                    rsp_next_state = RSP_IDLE;
                end
            end

            WAIT_DONE_OBI: begin
                if (curr_vx_valid == done_obi) begin
                    if (curr_vx_valid == curr_vx_rw) begin
                        done_all       = 1'b1;
                        rsp_next_state = RSP_IDLE;
                    end
                    else begin
                        rsp_next_state = VX_SEND_RSP;
                    end
                end
                else begin
                    rsp_next_state = WAIT_DONE_OBI;
                end
            end

            VX_SEND_RSP: begin
                vx_tmp_rsp.valid = 1'b1;
                if (vx_tmp_rsp.ready) begin
                    done_all       = 1'b1;
                    rsp_next_state = RSP_IDLE;
                end
                else begin
                    rsp_next_state = VX_SEND_RSP;
                end
            end

            default: begin
                rsp_next_state = RSP_IDLE;
            end

        endcase

    end

    assign done_all_tmp = done_all;

endmodule
