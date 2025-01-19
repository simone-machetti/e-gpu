// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module ctrl_logic
(
    input logic clk_i,
    input logic rst_ni,

    input logic gpu_start_i,

    input logic cu_sleep_req_i[`NUM_COMPUTE_UNITS],
    input logic cu_delay_sleep_i[`NUM_COMPUTE_UNITS],

    output logic cu_clk_en_o[`NUM_COMPUTE_UNITS],
    output logic cu_rst_n_o[`NUM_COMPUTE_UNITS],

    output logic l2_clk_en_o,
    output logic l2_rst_n_o
);

    parameter DELAY = 4;

    /*
    * GPU FSM
    */
    typedef enum logic [2:0] {GPU_IDLE, CU_START, L2_CLK_EN, L2_RST_N_DIS, L2_RST_N_EN} gpu_state_t;

    gpu_state_t               gpu_curr_state;
    gpu_state_t               gpu_next_state;

    logic                     cu_start;
    logic                     cu_end;

    logic [$clog2(DELAY)-1:0] l2_curr_cnt;
    logic [$clog2(DELAY)-1:0] l2_next_cnt;

    logic                     l2_cnt_en;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            l2_curr_cnt <= {$clog2(DELAY){1'b0}};
        end
        else begin
            l2_curr_cnt <= l2_next_cnt;
        end
    end

    assign l2_next_cnt = l2_cnt_en ? l2_curr_cnt + {$clog2(DELAY){1'b1}} : l2_curr_cnt;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            gpu_curr_state <= GPU_IDLE;
        end
        else begin
            gpu_curr_state <= gpu_next_state;
        end
    end

    always_comb begin

        gpu_next_state = gpu_curr_state;
        l2_clk_en_o    = 1'b0;
        l2_rst_n_o     = 1'b0;
        l2_cnt_en      = 1'b0;
        cu_start       = 1'b0;

        case(gpu_curr_state)

            GPU_IDLE: begin
                if (gpu_start_i) begin
                    gpu_next_state = CU_START;
                end
                else begin
                    gpu_next_state = GPU_IDLE;
                end
            end

            CU_START: begin
                cu_start       = 1'b1;
                gpu_next_state = L2_CLK_EN;
            end

            L2_CLK_EN: begin
                l2_clk_en_o = 1'b1;
                l2_cnt_en   = 1'b1;
                if (l2_curr_cnt < {$clog2(DELAY){1'b1}}) begin
                    gpu_next_state = L2_CLK_EN;
                end
                else begin
                    gpu_next_state = L2_RST_N_DIS;
                end
            end

            L2_RST_N_DIS: begin
                l2_clk_en_o = 1'b1;
                l2_rst_n_o  = 1'b1;
                if (cu_end) begin
                    gpu_next_state = L2_RST_N_EN;
                end
                else begin
                    gpu_next_state = L2_RST_N_DIS;
                end
            end

            L2_RST_N_EN: begin
                l2_clk_en_o = 1'b1;
                l2_cnt_en   = 1'b1;
                if (l2_curr_cnt < {$clog2(DELAY){1'b1}}) begin
                    gpu_next_state = L2_RST_N_EN;
                end
                else begin
                    gpu_next_state = GPU_IDLE;
                end
            end

            default: begin
                gpu_next_state = GPU_IDLE;
            end

        endcase

    end

    /*
    * Compute unit FSMs
    */
    typedef enum logic [2:0] {CU_IDLE, CU_CLK_EN, CU_RST_N_DIS, CU_RST_N_EN} cu_state_t;

    cu_state_t                     cu_curr_state[`NUM_COMPUTE_UNITS];
    cu_state_t                     cu_next_state[`NUM_COMPUTE_UNITS];

    logic [`NUM_COMPUTE_UNITS-1:0] cu_curr_sleep;
    logic [`NUM_COMPUTE_UNITS-1:0] cu_next_sleep;

    logic [     $clog2(DELAY)-1:0] cu_curr_cnt[`NUM_COMPUTE_UNITS];
    logic [     $clog2(DELAY)-1:0] cu_next_cnt[`NUM_COMPUTE_UNITS];

    logic                          cu_cnt_en[`NUM_COMPUTE_UNITS];

    assign cu_end = (cu_curr_sleep == {`NUM_COMPUTE_UNITS{1'b1}}) ? 1'b1 : 1'b0;

    generate

        for (genvar cu = 0; cu < `NUM_COMPUTE_UNITS; cu++) begin : gen_controller_logic_fsm

            always_ff @(posedge clk_i or negedge rst_ni) begin
                if (!rst_ni) begin
                    cu_curr_cnt[cu] <= {$clog2(DELAY){1'b0}};
                end
                else begin
                    cu_curr_cnt[cu] <= cu_next_cnt[cu];
                end
            end

            assign cu_next_cnt[cu] = cu_cnt_en[cu] ? cu_curr_cnt[cu] + {$clog2(DELAY){1'b1}} : cu_curr_cnt[cu];

            always_ff @(posedge clk_i or negedge rst_ni) begin
                if (!rst_ni) begin
                    cu_curr_sleep[cu] = 1'b0;
                end
                else begin
                    cu_curr_sleep[cu] = cu_next_sleep[cu];
                end
            end

            assign cu_next_sleep[cu] = cu_start ? 1'b0 : cu_sleep_req_i[cu] | cu_curr_sleep[cu];

            always_ff @(posedge clk_i or negedge rst_ni) begin
                if (!rst_ni) begin
                    cu_curr_state[cu] <= CU_IDLE;
                end
                else begin
                    cu_curr_state[cu] <= cu_next_state[cu];
                end
            end

            always_comb begin

                cu_next_state[cu] = cu_curr_state[cu];
                cu_clk_en_o[cu]   = 1'b0;
                cu_rst_n_o[cu]    = 1'b0;
                cu_cnt_en[cu]     = 1'b0;

                case(cu_curr_state[cu])

                    CU_IDLE: begin
                        if (cu_start) begin
                            cu_next_state[cu] = CU_CLK_EN;
                        end
                        else begin
                            cu_next_state[cu] = CU_IDLE;
                        end
                    end

                    CU_CLK_EN: begin
                        cu_clk_en_o[cu] = 1'b1;
                        cu_cnt_en[cu]   = 1'b1;
                        if (cu_curr_cnt[cu] < {$clog2(DELAY){1'b1}}) begin
                            cu_next_state[cu] = CU_CLK_EN;
                        end
                        else begin
                            cu_next_state[cu] = CU_RST_N_DIS;
                        end
                    end

                    CU_RST_N_DIS: begin
                        cu_clk_en_o[cu] = 1'b1;
                        cu_rst_n_o[cu]  = 1'b1;
                        if (cu_curr_sleep[cu] && !cu_delay_sleep_i[cu]) begin
                            cu_next_state[cu] = CU_RST_N_EN;
                        end
                        else begin
                            cu_next_state[cu] = CU_RST_N_DIS;
                        end
                    end

                    CU_RST_N_EN: begin
                        cu_clk_en_o[cu] = 1'b1;
                        cu_cnt_en[cu]   = 1'b1;
                        if (cu_curr_cnt[cu] < {$clog2(DELAY){1'b1}}) begin
                            cu_next_state[cu] = CU_RST_N_EN;
                        end
                        else begin
                            cu_next_state[cu] = CU_IDLE;
                        end
                    end

                    default: begin
                        cu_next_state[cu] = CU_IDLE;
                    end

                endcase

            end

        end

    endgenerate

endmodule
