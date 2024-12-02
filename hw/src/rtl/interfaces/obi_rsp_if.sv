// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`ifndef OBI_RSP_IF
`define OBI_RSP_IF

`include "e_gpu.vh"

interface obi_rsp_if ();

    logic        rvalid;
    logic [31:0] rdata;

    modport master (
        input rvalid,
        input rdata
    );

    modport slave (
        output rvalid,
        output rdata
    );

endinterface

`endif
