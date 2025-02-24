`include "VX_define.vh"

module VX_icache_stage #(
    parameter CORE_ID = 0
) (
    `SCOPE_IO_VX_icache_stage

    input  wire             clk,
    input  wire             reset,

    // Icache interface
    VX_icache_req_if.master icache_req_if,
    VX_icache_rsp_if.slave  icache_rsp_if,

    // request
    VX_ifetch_req_if.slave  ifetch_req_if,

    // reponse
    VX_ifetch_rsp_if.master ifetch_rsp_if
);

    `UNUSED_PARAM (CORE_ID)
    `UNUSED_VAR (reset)

    localparam OUT_REG = 0;

    wire [`NW_BITS-1:0] req_tag, rsp_tag;

    wire icache_req_fire = icache_req_if.valid && icache_req_if.ready;

    assign req_tag = ifetch_req_if.wid;
    assign rsp_tag = icache_rsp_if.tag[`NW_BITS-1:0];

    wire [`UUID_BITS-1:0] rsp_uuid;
    wire [31:0] rsp_PC;
    wire [`NUM_THREADS-1:0] rsp_tmask;

    double_port_mem_wrapper #(
        .DATAW   (32 + `NUM_THREADS + `UUID_BITS),
        .SIZE    (`NUM_WARPS),
        .OUT_REG (0)
    ) req_metadata_i (
        .clk_i   (clk),
        .rst_ni  (~reset),
        .wren_i  (icache_req_fire),
        .waddr_i (req_tag),
        .wdata_i ({ifetch_req_if.PC, ifetch_req_if.tmask, ifetch_req_if.uuid}),
        .raddr_i (rsp_tag),
        .rdata_o ({rsp_PC, rsp_tmask, rsp_uuid})
    );

    `RUNTIME_ASSERT((!ifetch_req_if.valid || ifetch_req_if.PC >= `STARTUP_ADDR),
        ("%t: *** invalid PC=%0h, wid=%0d, tmask=%b (#%0d)", $time, ifetch_req_if.PC, ifetch_req_if.wid, ifetch_req_if.tmask, ifetch_req_if.uuid))

    // Icache Request
    assign icache_req_if.valid = ifetch_req_if.valid;
    assign icache_req_if.addr  = ifetch_req_if.PC[31:2];
    assign icache_req_if.tag   = {ifetch_req_if.uuid, req_tag};

    // Can accept new request?
    assign ifetch_req_if.ready = icache_req_if.ready;

    wire [`NW_BITS-1:0] rsp_wid = rsp_tag;

    wire stall_out = ~ifetch_rsp_if.ready && (0 == OUT_REG && ifetch_rsp_if.valid);

    VX_pipe_register #(
        .DATAW  (1 + `NW_BITS + `NUM_THREADS + 32 + 32 + `UUID_BITS),
        .RESETW (1),
        .DEPTH  (OUT_REG)
    ) pipe_reg (
        .clk      (clk),
        .reset    (reset),
        .enable   (!stall_out),
        .data_in  ({icache_rsp_if.valid, rsp_wid,           rsp_tmask,           rsp_PC,           icache_rsp_if.data, rsp_uuid}),
        .data_out ({ifetch_rsp_if.valid, ifetch_rsp_if.wid, ifetch_rsp_if.tmask, ifetch_rsp_if.PC, ifetch_rsp_if.data, ifetch_rsp_if.uuid})
    );

    // Can accept new response?
    assign icache_rsp_if.ready = ~stall_out;

    `SCOPE_ASSIGN (icache_req_fire, icache_req_fire);
    `SCOPE_ASSIGN (icache_req_uuid, ifetch_req_if.uuid);
    `SCOPE_ASSIGN (icache_req_addr, {icache_req_if.addr, 2'b0});
    `SCOPE_ASSIGN (icache_req_tag,  req_tag);

    `SCOPE_ASSIGN (icache_rsp_fire, icache_rsp_if.valid && icache_rsp_if.ready);
    `SCOPE_ASSIGN (icache_rsp_uuid, rsp_uuid);
    `SCOPE_ASSIGN (icache_rsp_data, icache_rsp_if.data);
    `SCOPE_ASSIGN (icache_rsp_tag,  rsp_tag);

`ifdef DBG_TRACE_CORE_ICACHE
    always @(posedge clk) begin
        if (icache_req_fire) begin
            dpi_trace("%d: I$%0d req: wid=%0d, PC=%0h (#%0d)\n", $time, CORE_ID, ifetch_req_if.wid, ifetch_req_if.PC, ifetch_req_if.uuid);
        end
        if (ifetch_rsp_if.valid && ifetch_rsp_if.ready) begin
            dpi_trace("%d: I$%0d rsp: wid=%0d, PC=%0h, data=%0h (#%0d)\n", $time, CORE_ID, ifetch_rsp_if.wid, ifetch_rsp_if.PC, ifetch_rsp_if.data, ifetch_rsp_if.uuid);
        end
    end
`endif

endmodule
