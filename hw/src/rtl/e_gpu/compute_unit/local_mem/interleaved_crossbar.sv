// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module interleaved_crossbar
    import mem_map_pkg::*;
#(
    parameter NUM_MASTER     = 4,
    parameter NUM_SLAVE      = 4,
    parameter IL_ADDR_OFFSET = 32'h00008000,
    parameter IL_ADDR_SIZE   = 32'h00020000
)(
    input logic clk_i,
    input logic rst_ni,

    input mem_map_pkg::mem_map_t [NUM_SLAVE-1:0] addr_map_i,

    input logic [$clog2(NUM_SLAVE)-1:0] default_idx_i,

    obi_req_if.slave  master_req [NUM_MASTER],
    obi_rsp_if.master master_rsp [NUM_MASTER],

    obi_req_if.master slave_req [NUM_SLAVE],
    obi_rsp_if.slave  slave_rsp [NUM_SLAVE]
);
    localparam IL_ADDR_SLAVE_SIZE = IL_ADDR_SIZE/NUM_SLAVE;
    localparam REQ_AGG_DATA_WIDTH = 1 + 4 + 32 + 32;
    localparam RSP_AGG_DATA_WIDTH = 32;

    logic [NUM_MASTER-1:0][ $clog2(NUM_SLAVE)-1:0] port_sel;

    logic [NUM_MASTER-1:0]                         master_req_req;
    logic [NUM_MASTER-1:0][REQ_AGG_DATA_WIDTH-1:0] master_req_data;
    logic [NUM_MASTER-1:0]                         master_req_gnt;
    logic [NUM_MASTER-1:0][                  31:0] master_rsp_rdata;
    logic [NUM_MASTER-1:0]                         master_rsp_rvalid;

    logic [NUM_SLAVE-1:0]                          slave_req_req;
    logic [NUM_SLAVE-1:0][ REQ_AGG_DATA_WIDTH-1:0] slave_req_data;
    logic [NUM_SLAVE-1:0]                          slave_req_gnt;
    logic [NUM_SLAVE-1:0][                   31:0] slave_rsp_rdata;
    logic [NUM_SLAVE-1:0]                          slave_rsp_rvalid;

    logic [NUM_MASTER-1:0][                  31:0] master_req_addr_decoder;
    logic [NUM_MASTER-1:0][                  31:0] master_req_addr_xbar;

    logic [NUM_MASTER-1:0][                  31:0] master_req_addr;

    logic                 [                  31:0] zero = 32'h00000000;

    generate

        for (genvar m = 0; m < NUM_MASTER; m++) begin : gen_master_connections

            assign master_req_addr[m]         = master_req[m].addr-IL_ADDR_OFFSET;
            assign master_req_addr_decoder[m] = {zero           [31:$clog2(NUM_SLAVE)+$clog2(IL_ADDR_SLAVE_SIZE)],
                                                 master_req_addr[m][$clog2(NUM_SLAVE)+1:2],
                                                 master_req_addr[m][$clog2(NUM_SLAVE)+$clog2(IL_ADDR_SLAVE_SIZE)-1:$clog2(NUM_SLAVE)+2],
                                                 master_req_addr[m][1:0]};
            assign master_req_addr_xbar[m]    = {zero           [31:$clog2(NUM_SLAVE)+$clog2(IL_ADDR_SLAVE_SIZE)-$clog2(NUM_SLAVE)],
                                                 master_req_addr[m][$clog2(NUM_SLAVE)+$clog2(IL_ADDR_SLAVE_SIZE)-1:$clog2(NUM_SLAVE)+2],
                                                 master_req_addr[m][1:0]};

            assign master_req_req[m]          = master_req[m].req;
            assign master_req_data[m]         = {master_req[m].we, master_req[m].be, master_req_addr_xbar[m], master_req[m].wdata};
            assign master_req[m].gnt          = master_req_gnt[m];
            assign master_rsp[m].rdata        = master_rsp_rdata[m];
            assign master_rsp[m].rvalid       = master_rsp_rvalid[m];

            addr_decode #(
                .NoIndices        (NUM_SLAVE),
                .NoRules          (NUM_SLAVE),
                .addr_t           (logic [31:0]),
                .rule_t           (mem_map_pkg::mem_map_t)
            ) addr_decode_i (
                .addr_i           (master_req_addr_decoder[m]),
                .addr_map_i       (addr_map_i),
                .idx_o            (port_sel[m]),
                .dec_valid_o      (),
                .dec_error_o      (),
                .en_default_idx_i (1'b1),
                .default_idx_i    (default_idx_i)
            );

        end

    endgenerate

    generate

        for (genvar s = 0; s < NUM_SLAVE; s++) begin : gen_slave_connections

            assign slave_req[s].req                                                          = slave_req_req[s];
            assign {slave_req[s].we, slave_req[s].be, slave_req[s].addr, slave_req[s].wdata} = slave_req_data[s];
            assign slave_req_gnt[s]                                                          = slave_req[s].gnt;
            assign slave_rsp_rdata[s]                                                        = slave_rsp[s].rdata;
            assign slave_rsp_rvalid[s]                                                       = slave_rsp[s].rvalid;

        end

    endgenerate

    xbar_varlat #(
        .AggregateGnt  (1),
        .NumIn         (NUM_MASTER),
        .NumOut        (NUM_SLAVE),
        .ReqDataWidth  (REQ_AGG_DATA_WIDTH),
        .RespDataWidth (RSP_AGG_DATA_WIDTH)
    ) xbar_varlat_i (
        .clk_i         (clk_i),
        .rst_ni        (rst_ni),
        .add_i         (port_sel),
        .req_i         (master_req_req),
        .wdata_i       (master_req_data),
        .gnt_o         (master_req_gnt),
        .rdata_o       (master_rsp_rdata),
        .rr_i          ('0),
        .vld_o         (master_rsp_rvalid),
        .req_o         (slave_req_req),
        .wdata_o       (slave_req_data),
        .gnt_i         (slave_req_gnt),
        .rdata_i       (slave_rsp_rdata),
        .vld_i         (slave_rsp_rvalid)
    );

endmodule
