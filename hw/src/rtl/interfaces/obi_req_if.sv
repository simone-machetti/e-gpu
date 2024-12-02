// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`ifndef OBI_REQ_IF
`define OBI_REQ_IF

`include "e_gpu.vh"

interface obi_req_if ();

    logic        req;
    logic        we;
    logic [3:0]  be;
    logic [31:0] addr;
    logic [31:0] wdata;
    logic        gnt;

    modport master (
        output req,
        output we,
        output be,
        output addr,
        output wdata,
        input  gnt
    );

    modport slave (
        input  req,
        input  we,
        input  be,
        input  addr,
        input  wdata,
        output gnt
    );

endinterface

`endif
