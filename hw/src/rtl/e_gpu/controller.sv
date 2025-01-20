// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module controller
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
    output logic l2_rst_n_o,

    output logic interrupt_o
);

    logic start;
    logic int_event;

    ctrl_logic ctrl_logic_i (
        .clk_i            (clk_i),
        .rst_ni           (rst_ni),
        .start_i          (start),
        .cu_sleep_req_i   (cu_sleep_req_i),
        .cu_delay_sleep_i (cu_delay_sleep_i),
        .cu_clk_en_o      (cu_clk_en_o),
        .cu_rst_n_o       (cu_rst_n_o),
        .l2_clk_en_o      (l2_clk_en_o),
        .l2_rst_n_o       (l2_rst_n_o),
        .int_event_o      (int_event)
    );

    config_regs config_regs_i (
        .clk_i       (clk_i),
        .rst_ni      (rst_ni),
        .regs_req    (regs_req),
        .regs_rsp    (regs_rsp),
        .int_event_i (int_event),
        .start_o     (start),
        .interrupt_o (interrupt_o)
    );

endmodule
