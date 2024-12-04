// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module controller_cache
(
    input logic clk_i,
    input logic rst_ni,

    obi_req_if.slave  regs_req,
    obi_rsp_if.master regs_rsp,

    input logic cu_sleep_req_i[`NUM_COMPUTE_UNITS],
    input logic cu_delay_sleep_i[`NUM_COMPUTE_UNITS],

    output logic cu_clk_en_o[`NUM_COMPUTE_UNITS],
    output logic cu_rst_n_o[`NUM_COMPUTE_UNITS],

    output logic l2_clk_en_o,
    output logic l2_rst_n_o
);

    logic gpu_start;

    logic_cache logic_cache_i (
        .clk_i            (clk_i),
        .rst_ni           (rst_ni),
        .gpu_start_i      (gpu_start),
        .cu_sleep_req_i   (cu_sleep_req_i),
        .cu_delay_sleep_i (cu_delay_sleep_i),
        .cu_clk_en_o      (cu_clk_en_o),
        .cu_rst_n_o       (cu_rst_n_o),
        .l2_clk_en_o      (l2_clk_en_o),
        .l2_rst_n_o       (l2_rst_n_o)
    );

    config_regs_cache config_regs_cache_i (
        .clk_i       (clk_i),
        .rst_ni      (rst_ni),
        .regs_req    (regs_req),
        .regs_rsp    (regs_rsp),
        .gpu_start_o (gpu_start)
    );

endmodule
