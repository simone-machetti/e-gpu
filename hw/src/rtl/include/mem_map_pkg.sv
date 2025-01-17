// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

package mem_map_pkg;

    typedef struct packed {
        logic [31:0] idx;
        logic [31:0] start_addr;
        logic [31:0] end_addr;
    } mem_map_t;

    localparam logic [31:0] RAM_BANK_SIZE = 32'h8000;

    localparam logic [31:0] GLOBAL_MEM_IDX           = 32'd0;
    localparam logic [31:0] GLOBAL_MEM_START_ADDRESS = 32'h00000000;
    localparam logic [31:0] GLOBAL_MEM_END_ADDRESS   = 32'h00020000;

    localparam logic [31:0] LOCAL_MEM_IDX           = 32'd1;
    localparam logic [31:0] LOCAL_MEM_START_ADDRESS = 32'h00020000;
    localparam logic [31:0] LOCAL_MEM_END_ADDRESS   = 32'h00030000;

    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_0_IDX           = 32'd0;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_0_START_ADDRESS = 32'h00000000;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_0_END_ADDRESS   = 32'h00002000;

    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_1_IDX           = 32'd1;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_1_START_ADDRESS = 32'h00002000;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_1_END_ADDRESS   = 32'h00004000;

    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_2_IDX           = 32'd2;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_2_START_ADDRESS = 32'h00004000;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_2_END_ADDRESS   = 32'h00006000;

    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_3_IDX           = 32'd3;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_3_START_ADDRESS = 32'h00006000;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_3_END_ADDRESS   = 32'h00008000;

    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_4_IDX           = 32'd4;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_4_START_ADDRESS = 32'h00008000;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_4_END_ADDRESS   = 32'h0000A000;

    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_5_IDX           = 32'd5;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_5_START_ADDRESS = 32'h0000A000;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_5_END_ADDRESS   = 32'h0000C000;

    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_6_IDX           = 32'd6;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_6_START_ADDRESS = 32'h0000C000;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_6_END_ADDRESS   = 32'h0000E000;

    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_7_IDX           = 32'd7;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_7_START_ADDRESS = 32'h0000E000;
    localparam logic [31:0] OFFSET_LOCAL_MEM_BANK_7_END_ADDRESS   = 32'h00010000;

    localparam mem_map_t [1:0] MEM_RULES = '{
        '{idx: GLOBAL_MEM_IDX, start_addr: GLOBAL_MEM_START_ADDRESS, end_addr: GLOBAL_MEM_END_ADDRESS},
        '{idx: LOCAL_MEM_IDX,  start_addr: LOCAL_MEM_START_ADDRESS,  end_addr: LOCAL_MEM_END_ADDRESS }
    };

    localparam mem_map_t [7:0] LOCAL_MEM_RULES = '{
        '{idx: OFFSET_LOCAL_MEM_BANK_0_IDX, start_addr: OFFSET_LOCAL_MEM_BANK_0_START_ADDRESS, end_addr: OFFSET_LOCAL_MEM_BANK_0_END_ADDRESS},
        '{idx: OFFSET_LOCAL_MEM_BANK_1_IDX, start_addr: OFFSET_LOCAL_MEM_BANK_1_START_ADDRESS, end_addr: OFFSET_LOCAL_MEM_BANK_1_END_ADDRESS},
        '{idx: OFFSET_LOCAL_MEM_BANK_2_IDX, start_addr: OFFSET_LOCAL_MEM_BANK_2_START_ADDRESS, end_addr: OFFSET_LOCAL_MEM_BANK_2_END_ADDRESS},
        '{idx: OFFSET_LOCAL_MEM_BANK_3_IDX, start_addr: OFFSET_LOCAL_MEM_BANK_3_START_ADDRESS, end_addr: OFFSET_LOCAL_MEM_BANK_3_END_ADDRESS},
        '{idx: OFFSET_LOCAL_MEM_BANK_4_IDX, start_addr: OFFSET_LOCAL_MEM_BANK_4_START_ADDRESS, end_addr: OFFSET_LOCAL_MEM_BANK_4_END_ADDRESS},
        '{idx: OFFSET_LOCAL_MEM_BANK_5_IDX, start_addr: OFFSET_LOCAL_MEM_BANK_5_START_ADDRESS, end_addr: OFFSET_LOCAL_MEM_BANK_5_END_ADDRESS},
        '{idx: OFFSET_LOCAL_MEM_BANK_6_IDX, start_addr: OFFSET_LOCAL_MEM_BANK_6_START_ADDRESS, end_addr: OFFSET_LOCAL_MEM_BANK_6_END_ADDRESS},
        '{idx: OFFSET_LOCAL_MEM_BANK_7_IDX, start_addr: OFFSET_LOCAL_MEM_BANK_7_START_ADDRESS, end_addr: OFFSET_LOCAL_MEM_BANK_7_END_ADDRESS}
    };

endpackage
