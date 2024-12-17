// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module single_port_mem_wrapper #(
    parameter DATAW               = 1,
    parameter SIZE                = 1,
    parameter BYTEENW             = 1,
    parameter ADDRW               = $clog2(SIZE),
    parameter NUM_BANKS_PER_GROUP = (SIZE  % 256) ? ((SIZE  / 256) + 1) : (SIZE  / 256),
    parameter NUM_GROUPS          = (DATAW %  32) ? ((DATAW /  32) + 1) : (DATAW /  32),
    parameter NUM_BANKS_BITS      = $clog2(NUM_BANKS_PER_GROUP)
)(
    input  logic               clk_i,
    input  logic               rst_ni,
    input  logic [ADDRW-1:0]   addr_i,
    input  logic [BYTEENW-1:0] wren_i,
    input  logic [DATAW-1:0]   wdata_i,
    output logic [DATAW-1:0]   rdata_o
);

`ifdef ARM_SRAM

    localparam BANK_WORD_BITS    = 32;
    localparam BANK_ADDR_BITS    = 8;
    localparam BANK_BYTEENW_BITS = 4;
    localparam BANK_BITENW_BITS  = 32;

    logic [(NUM_BANKS_BITS+BANK_ADDR_BITS)-1:0] addr;
    logic                                       cen[NUM_BANKS_PER_GROUP];

    logic [                  (BYTEENW*8)-1:0] wren_bit;
    logic [(BANK_BITENW_BITS*NUM_GROUPS)-1:0] wren;

    logic [  (BANK_WORD_BITS*NUM_GROUPS)-1:0] wdata;

    logic [             BANK_WORD_BITS-1:0] rdata[NUM_BANKS_PER_GROUP][NUM_GROUPS];
    logic [(BANK_WORD_BITS*NUM_GROUPS)-1:0] rdata_out;

    if (ADDRW > BANK_ADDR_BITS) begin
        always_comb begin
            addr = addr_i;
            for (int bank = 0; bank < NUM_BANKS_PER_GROUP; bank++) begin
                cen[bank] = 1'b0;
            end
            cen[addr[NUM_BANKS_BITS+(BANK_ADDR_BITS-1):BANK_ADDR_BITS]] = 1'b1;
        end
    end
    else if (ADDRW == BANK_ADDR_BITS) begin
        assign addr   = addr_i;
        assign cen[0] = 1'b1;
    end
    else begin
        assign addr   = {{(BANK_ADDR_BITS-ADDRW){1'b0}}, addr_i};
        assign cen[0] = 1'b1;
    end

    if (BYTEENW > 1) begin
        for (genvar i = 0; i < BYTEENW; i++) begin
            assign wren_bit[(i*8)+7:i*8] = {8{wren_i[i]}};
        end
        if (DATAW == (BANK_WORD_BITS*NUM_GROUPS)) begin
            assign wren = wren_bit;
        end
        else begin
            assign wren = {{((BANK_WORD_BITS*NUM_GROUPS)-DATAW){1'b0}}, wren_bit};
        end
    end

    if (DATAW == (BANK_WORD_BITS*NUM_GROUPS)) begin
        assign wdata = wdata_i;
    end
    else begin
        assign wdata = {{((BANK_WORD_BITS*NUM_GROUPS)-DATAW){1'b0}}, wdata_i};
    end

    assign rdata_o = rdata_out[DATAW-1:0];

    generate

        for (genvar group = 0; group < NUM_GROUPS; group++) begin : gen_groups

            for (genvar bank = 0; bank < NUM_BANKS_PER_GROUP; bank++) begin : gen_banks

                if (BYTEENW > 1) begin

                    rf256x32m2 arm_sram_i (
                        .CTLSO     (),
                        .Q         (rdata[bank][group]),
                        .SO        (),
                        .WENSO     (),
                        .PRDYN     (),
                        .CLK       (clk_i),
                        .CEN       (~rst_ni | ~cen[bank]),
                        .GWEN      (~(|wren[((BANK_BITENW_BITS*group)+(BANK_BITENW_BITS-1)):(BANK_BITENW_BITS*group)])),
                        .A         (addr[(BANK_ADDR_BITS-1):0]),
                        .D         (wdata[((BANK_WORD_BITS*group)+(BANK_WORD_BITS-1)):(BANK_WORD_BITS*group)]),
                        .WEN       (~wren[((BANK_BITENW_BITS*group)+(BANK_BITENW_BITS-1)):(BANK_BITENW_BITS*group)]),
                        .STOV      (1'b0),
                        .EMA       (3'b111),
                        .EMAW      (2'b11),
                        .EMAS      (1'b1),
                        .TEN       (1'b1),
                        .TCEN      (1'b1),
                        .TGWEN     (1'b1),
                        .TA        (8'd0),
                        .TD        (32'd0),
                        .TWEN      (32'd0),
                        .SI        (2'b00),
                        .SE        (1'b0),
                        .DFTRAMBYP (1'b0),
                        .PGEN      (1'b0),
                        .RET1N     (1'b1),
                        .RET2N     (1'b1),
                        .CTLSI     (1'b0),
                        .WENSI     (2'b0)
                    );

                end
                else begin

                    rf256x32m2 arm_sram_i (
                        .CTLSO     (),
                        .Q         (rdata[bank][group]),
                        .SO        (),
                        .WENSO     (),
                        .PRDYN     (),
                        .CLK       (clk_i),
                        .CEN       (~rst_ni | ~cen[bank]),
                        .GWEN      (~wren_i),
                        .A         (addr[(BANK_ADDR_BITS-1):0]),
                        .D         (wdata[((BANK_WORD_BITS*group)+(BANK_WORD_BITS-1)):(BANK_WORD_BITS*group)]),
                        .WEN       ({BANK_BITENW_BITS{~wren_i}}),
                        .STOV      (1'b0),
                        .EMA       (3'b111),
                        .EMAW      (2'b11),
                        .EMAS      (1'b1),
                        .TEN       (1'b1),
                        .TCEN      (1'b1),
                        .TGWEN     (1'b1),
                        .TA        (8'd0),
                        .TD        (32'd0),
                        .TWEN      (32'd0),
                        .SI        (2'b00),
                        .SE        (1'b0),
                        .DFTRAMBYP (1'b0),
                        .PGEN      (1'b0),
                        .RET1N     (1'b1),
                        .RET2N     (1'b1),
                        .CTLSI     (1'b0),
                        .WENSI     (2'b0)
                    );

                end

            end

            if (NUM_BANKS_PER_GROUP > 1) begin
                assign rdata_out[((BANK_WORD_BITS*group)+(BANK_WORD_BITS-1)):(BANK_WORD_BITS*group)] = rdata[addr[NUM_BANKS_BITS+(BANK_ADDR_BITS-1):BANK_ADDR_BITS]][group];
            end
            else begin
                assign rdata_out[((BANK_WORD_BITS*group)+(BANK_WORD_BITS-1)):(BANK_WORD_BITS*group)] = rdata[0][group];
            end

        end

    endgenerate

`else

    single_port_mem_behavioral #(
        .DATAW   (DATAW),
        .SIZE    (SIZE),
        .BYTEENW (BYTEENW)
    ) single_port_mem_behavioral_i (
        .clk_i   (clk_i),
        .rst_ni  (rst_ni),
        .addr_i  (addr_i),
        .wren_i  (wren_i),
        .wdata_i (wdata_i),
        .rdata_o (rdata_o)
    );

`endif

endmodule
