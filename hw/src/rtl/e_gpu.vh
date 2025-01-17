// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`ifndef E_GPU
`define E_GPU

`define NUM_COMPUTE_UNITS 2
`define NUM_WARPS         4
`define NUM_THREADS       8

`define STARTUP_ADDR 32'h00000000

`define LOCAL_MEM_SIZE 32768

// `define ARM_SRAM

`include "VX_define.vh"

`endif
