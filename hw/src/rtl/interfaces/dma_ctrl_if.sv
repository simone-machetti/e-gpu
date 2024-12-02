// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`ifndef DMA_IF
`define DMA_IF

`include "e_gpu.vh"

interface dma_ctrl_if ();

    logic [31:0] len;
    logic [31:0] src;
    logic [31:0] dst;
    logic        dir;
    logic        start;
    logic        done;

    modport master (
        output len,
        output src,
        output dst,
        output start,
        output dir,
        input  done
    );

    modport slave (
        input  len,
        input  src,
        input  dst,
        input  start,
        input  dir,
        output done
    );

endinterface

`endif
