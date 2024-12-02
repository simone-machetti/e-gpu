// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`ifndef VX_CACHE_REQ_IF
`define VX_CACHE_REQ_IF

`include "e_gpu.vh"

interface VX_cache_req_if #(
    parameter NUM_REQS   = 2,
    parameter DATA_WIDTH = 1,
    parameter ADDR_WIDTH = 1,
    parameter TAG_WIDTH  = 1,
    parameter DATA_SIZE  = DATA_WIDTH / 8
) ();

    wire [NUM_REQS-1:0]                 valid;
    wire [NUM_REQS-1:0]                 rw;
    wire [NUM_REQS-1:0][DATA_SIZE-1:0]  byteen;
    wire [NUM_REQS-1:0][ADDR_WIDTH-1:0] addr;
    wire [NUM_REQS-1:0][DATA_WIDTH-1:0] data;
    wire [NUM_REQS-1:0][TAG_WIDTH-1:0]  tag;
    wire [NUM_REQS-1:0]                 ready;

    modport master (
        output valid,
        output rw,
        output byteen,
        output addr,
        output data,
        output tag,
        input  ready
    );

    modport slave (
        input  valid,
        input  rw,
        input  byteen,
        input  addr,
        input  data,
        input  tag,
        output ready
    );

endinterface

`endif
