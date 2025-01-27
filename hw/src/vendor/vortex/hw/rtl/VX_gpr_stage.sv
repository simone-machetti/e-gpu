`include "VX_define.vh"

module VX_gpr_stage #(
    parameter CORE_ID = 0
) (
    input wire              clk,
    input wire              reset,

    // inputs
    VX_writeback_if.slave   writeback_if,
    VX_gpr_req_if.slave     gpr_req_if,

    // outputs
    VX_gpr_rsp_if.master    gpr_rsp_if
);

    `UNUSED_PARAM (CORE_ID)
    `UNUSED_VAR (reset)

    localparam RAM_SIZE = `NUM_WARPS * `NUM_REGS;

    // ensure r0 never gets written, which can happen before the reset
    wire write_enable = writeback_if.valid && (writeback_if.rd != 0);

    wire [`NUM_THREADS-1:0] wren;
    for (genvar i = 0; i < `NUM_THREADS; ++i) begin
        assign wren[i] = write_enable && writeback_if.tmask[i];
    end

    wire [$clog2(RAM_SIZE)-1:0] waddr, raddr1, raddr2;
    assign waddr  = {writeback_if.wid, writeback_if.rd};
    assign raddr1 = {gpr_req_if.wid, gpr_req_if.rs1};
    assign raddr2 = {gpr_req_if.wid, gpr_req_if.rs2};

    for (genvar i = 0; i < `NUM_THREADS; ++i) begin

        triple_port_mem_wrapper #(
            .DATAW     (32),
            .SIZE      (RAM_SIZE),
            .OUT_REG   (0)
        ) triple_port_mem_wrapper_i (
            .clk_i     (clk),
            .rst_ni    (~reset),
            .wren_i    (wren[i]),
            .waddr_i   (waddr),
            .wdata_i   (writeback_if.data[i]),
            .raddr_1_i (raddr1),
            .rdata_1_o (gpr_rsp_if.rs1_data[i]),
            .raddr_2_i (raddr2),
            .rdata_2_o (gpr_rsp_if.rs2_data[i])
        );

    end

`ifdef EXT_F_ENABLE
    wire [$clog2(RAM_SIZE)-1:0] raddr3;
    assign raddr3 = {gpr_req_if.wid, gpr_req_if.rs3};

    for (genvar i = 0; i < `NUM_THREADS; ++i) begin
        double_port_mem_wrapper #(
            .DATAW   (32),
            .SIZE    (RAM_SIZE),
            .OUT_REG (0)
        ) dp_ram3_i (
            .clk_i   (clk),
            .rst_ni  (~reset),
            .wren_i  (wren[i]),
            .waddr_i (waddr),
            .wdata_i (writeback_if.data[i]),
            .raddr_i (raddr3),
            .rdata_o (gpr_rsp_if.rs3_data[i])
        );
    end
`else
    `UNUSED_VAR (gpr_req_if.rs3)
    assign gpr_rsp_if.rs3_data = 'x;
`endif

    assign writeback_if.ready = 1'b1;

endmodule
