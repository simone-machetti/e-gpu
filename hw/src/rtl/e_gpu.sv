// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module e_gpu
(
    input logic clk_i,
    input logic rst_ni,

    obi_req_if.slave  conf_regs_req,
    obi_rsp_if.master conf_regs_rsp,

    obi_req_if.master host_mem_req,
    obi_rsp_if.slave  host_mem_rsp
);

    logic clk_core;
    logic rst_n_core;

    logic cu_sleep_req[`NUM_COMPUTE_UNITS];
    logic cu_delay_sleep[`NUM_COMPUTE_UNITS];
    logic cu_clk_en[`NUM_COMPUTE_UNITS];
    logic cu_clk[`NUM_COMPUTE_UNITS];
    logic cu_rst_n[`NUM_COMPUTE_UNITS];

    logic l2_clk_en;
    logic l2_clk;
    logic l2_rst_n;

    VX_mem_req_if #(
        .DATA_WIDTH (`ICACHE_MEM_DATA_WIDTH),
        .ADDR_WIDTH (`ICACHE_MEM_ADDR_WIDTH),
        .TAG_WIDTH  (`ICACHE_MEM_TAG_WIDTH)
    ) l2_instr_cache_req[`NUM_COMPUTE_UNITS]();

    VX_mem_rsp_if #(
        .DATA_WIDTH (`ICACHE_MEM_DATA_WIDTH),
        .TAG_WIDTH  (`ICACHE_MEM_TAG_WIDTH)
    ) l2_instr_cache_rsp[`NUM_COMPUTE_UNITS]();

    VX_mem_req_if #(
        .DATA_WIDTH (`DCACHE_MEM_DATA_WIDTH),
        .ADDR_WIDTH (`DCACHE_MEM_ADDR_WIDTH),
        .TAG_WIDTH  (`DCACHE_MEM_TAG_WIDTH)
    ) l2_data_cache_req[`NUM_COMPUTE_UNITS]();

    VX_mem_rsp_if #(
        .DATA_WIDTH (`DCACHE_MEM_DATA_WIDTH),
        .TAG_WIDTH  (`DCACHE_MEM_TAG_WIDTH)
    ) l2_data_cache_rsp[`NUM_COMPUTE_UNITS]();

    VX_cache_req_if #(
        .NUM_REQS   (2 * `NUM_COMPUTE_UNITS),
        .DATA_WIDTH (`DCACHE_MEM_DATA_WIDTH),
        .ADDR_WIDTH (`DCACHE_MEM_ADDR_WIDTH),
        .TAG_WIDTH  (`DCACHE_MEM_TAG_WIDTH)
    ) l2_cache_req();

    VX_cache_rsp_if #(
        .NUM_REQS   (2 * `NUM_COMPUTE_UNITS),
        .DATA_WIDTH (`DCACHE_MEM_DATA_WIDTH),
        .TAG_WIDTH  (`DCACHE_MEM_TAG_WIDTH)
    ) l2_cache_rsp();

    generate

        for (genvar cu = 0; cu < `NUM_COMPUTE_UNITS; cu++) begin : gen_compute_unit

            compute_unit #(
                .COMPUTE_UNIT_ID    (cu)
            ) compute_unit_i (
                .clk_i              (cu_clk[cu]),
                .rst_ni             (cu_rst_n[cu]),
                .l2_instr_cache_req (l2_instr_cache_req[cu]),
                .l2_instr_cache_rsp (l2_instr_cache_rsp[cu]),
                .l2_data_cache_req  (l2_data_cache_req[cu]),
                .l2_data_cache_rsp  (l2_data_cache_rsp[cu]),
                .sleep_req_o        (cu_sleep_req[cu])
            );

            assign cu_delay_sleep[cu] = l2_data_cache_req[cu].valid;

            clock_gating_cell_wrapper cu_clock_gating_cell_i (
                .clk_i (clk_i),
                .en_i  (cu_clk_en[cu]),
                .clk_o (cu_clk[cu])
            );

            assign l2_cache_req.valid [(2 * cu)]     = l2_instr_cache_req[cu].valid;
            assign l2_cache_req.rw    [(2 * cu)]     = l2_instr_cache_req[cu].rw;
            assign l2_cache_req.byteen[(2 * cu)]     = l2_instr_cache_req[cu].byteen;
            assign l2_cache_req.addr  [(2 * cu)]     = l2_instr_cache_req[cu].addr;
            assign l2_cache_req.data  [(2 * cu)]     = l2_instr_cache_req[cu].data;
            assign l2_cache_req.tag   [(2 * cu)]     = {50'd0, l2_instr_cache_req[cu].tag};
            assign l2_instr_cache_req [cu].ready     = l2_cache_req.ready[(2 * cu)];

            assign l2_instr_cache_rsp[cu].valid      = l2_cache_rsp.valid[(2 * cu)];
            assign l2_instr_cache_rsp[cu].data       = l2_cache_rsp.data [(2 * cu)];
            assign l2_instr_cache_rsp[cu].tag        = l2_cache_rsp.tag  [(2 * cu)][0];
            assign l2_cache_rsp.ready[(2 * cu)]      = l2_instr_cache_rsp[cu].ready;

            assign l2_cache_req.valid [(2 * cu) + 1] = l2_data_cache_req [cu].valid;
            assign l2_cache_req.rw    [(2 * cu) + 1] = l2_data_cache_req [cu].rw;
            assign l2_cache_req.byteen[(2 * cu) + 1] = l2_data_cache_req [cu].byteen;
            assign l2_cache_req.addr  [(2 * cu) + 1] = l2_data_cache_req [cu].addr;
            assign l2_cache_req.data  [(2 * cu) + 1] = l2_data_cache_req [cu].data;
            assign l2_cache_req.tag   [(2 * cu) + 1] = l2_data_cache_req [cu].tag;
            assign l2_data_cache_req  [cu].ready     = l2_cache_req.ready[(2 * cu) + 1];

            assign l2_data_cache_rsp [cu].valid      = l2_cache_rsp.valid[(2 * cu) + 1];
            assign l2_data_cache_rsp [cu].data       = l2_cache_rsp.data [(2 * cu) + 1];
            assign l2_data_cache_rsp [cu].tag        = l2_cache_rsp.tag  [(2 * cu) + 1];
            assign l2_cache_rsp.ready[(2 * cu) + 1]  = l2_data_cache_rsp [cu].ready;

        end

    endgenerate

    l2_shared_cache l2_shared_cache_i (
        .clk_i        (l2_clk),
        .rst_ni       (l2_rst_n),
        .l2_cache_req (l2_cache_req),
        .l2_cache_rsp (l2_cache_rsp),
        .host_req     (host_mem_req),
        .host_rsp     (host_mem_rsp)
    );

    clock_gating_cell_wrapper l2_clock_gating_cell_i (
        .clk_i (clk_i),
        .en_i  (l2_clk_en),
        .clk_o (l2_clk)
    );

    controller_cache controller_cache_i (
        .clk_i            (clk_i),
        .rst_ni           (rst_ni),
        .regs_req         (conf_regs_req),
        .regs_rsp         (conf_regs_rsp),
        .cu_sleep_req_i   (cu_sleep_req),
        .cu_delay_sleep_i (cu_delay_sleep),
        .cu_clk_en_o      (cu_clk_en),
        .cu_rst_n_o       (cu_rst_n),
        .l2_clk_en_o      (l2_clk_en),
        .l2_rst_n_o       (l2_rst_n)
    );

endmodule
