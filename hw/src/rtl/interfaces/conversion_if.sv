// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`ifndef CONVERSION_IF
`define CONVERSION_IF

`include "e_gpu.vh"

interface cache_if_converter #(
    parameter NUM_COMPUTE_UNITS = 4,
    parameter DATA_WIDTH        = 32,
    parameter ADDR_WIDTH        = 32,
    parameter TAG_WIDTH         = 8
) ();

    // Input ports
    VX_mem_req_if #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH),
        .TAG_WIDTH  (TAG_WIDTH)
    ) instr_cache_req[NUM_COMPUTE_UNITS]();

    VX_mem_rsp_if #(
        .DATA_WIDTH (DATA_WIDTH),
        .TAG_WIDTH  (TAG_WIDTH)
    ) instr_cache_rsp[NUM_COMPUTE_UNITS]();

    VX_mem_req_if #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH),
        .TAG_WIDTH  (TAG_WIDTH)
    ) data_cache_req[NUM_COMPUTE_UNITS]();

    VX_mem_rsp_if #(
        .DATA_WIDTH (DATA_WIDTH),
        .TAG_WIDTH  (TAG_WIDTH)
    ) data_cache_rsp[NUM_COMPUTE_UNITS]();

    // Output ports
    VX_cache_req_if #(
        .NUM_REQS   (2 * NUM_COMPUTE_UNITS),
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH),
        .TAG_WIDTH  (TAG_WIDTH)
    ) l2_cache_req();

    VX_cache_rsp_if #(
        .NUM_REQS   (2 * NUM_COMPUTE_UNITS),
        .DATA_WIDTH (DATA_WIDTH),
        .TAG_WIDTH  (TAG_WIDTH)
    ) l2_cache_rsp();

    // Conversion logic
    generate
        for (genvar cu = 0; cu < NUM_COMPUTE_UNITS; cu++) begin : gen_conversion
            // Instruction cache requests
            assign l2_cache_req.valid [(2 * cu)]     = instr_cache_req[cu].valid;
            assign l2_cache_req.rw    [(2 * cu)]     = instr_cache_req[cu].rw;
            assign l2_cache_req.byteen[(2 * cu)]     = instr_cache_req[cu].byteen;
            assign l2_cache_req.addr  [(2 * cu)]     = instr_cache_req[cu].addr;
            assign l2_cache_req.data  [(2 * cu)]     = instr_cache_req[cu].data;
            assign l2_cache_req.tag   [(2 * cu)]     = {50'd0, instr_cache_req[cu].tag};
            assign instr_cache_req[cu].ready         = l2_cache_req.ready[(2 * cu)];

            assign instr_cache_rsp[cu].valid         = l2_cache_rsp.valid[(2 * cu)];
            assign instr_cache_rsp[cu].data          = l2_cache_rsp.data [(2 * cu)];
            assign instr_cache_rsp[cu].tag           = l2_cache_rsp.tag  [(2 * cu)][0];
            assign l2_cache_rsp.ready[(2 * cu)]      = instr_cache_rsp[cu].ready;

            // Data cache requests
            assign l2_cache_req.valid [(2 * cu) + 1] = data_cache_req[cu].valid;
            assign l2_cache_req.rw    [(2 * cu) + 1] = data_cache_req[cu].rw;
            assign l2_cache_req.byteen[(2 * cu) + 1] = data_cache_req[cu].byteen;
            assign l2_cache_req.addr  [(2 * cu) + 1] = data_cache_req[cu].addr;
            assign l2_cache_req.data  [(2 * cu) + 1] = data_cache_req[cu].data;
            assign l2_cache_req.tag   [(2 * cu) + 1] = data_cache_req[cu].tag;
            assign data_cache_req[cu].ready          = l2_cache_req.ready[(2 * cu) + 1];

            assign data_cache_rsp[cu].valid          = l2_cache_rsp.valid[(2 * cu) + 1];
            assign data_cache_rsp[cu].data           = l2_cache_rsp.data [(2 * cu) + 1];
            assign data_cache_rsp[cu].tag            = l2_cache_rsp.tag  [(2 * cu) + 1];
            assign l2_cache_rsp.ready[(2 * cu) + 1]  = data_cache_rsp[cu].ready;
        end
    endgenerate

endinterface

`endif
