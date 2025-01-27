`ifndef VX_ICACHE_CORE_REQ_IF
`define VX_ICACHE_CORE_REQ_IF

`include "../cache/VX_cache_define.vh"

interface VX_icache_req_if #(
    parameter WORD_SIZE = 1,
    parameter TAG_WIDTH = 1
) ();

    logic                        valid;
    logic [`WORD_ADDR_WIDTH-1:0] addr;
    logic [TAG_WIDTH-1:0]        tag;
    logic                        ready;

    modport master (
        output valid,
        output addr,
        output tag,
        input  ready
    );

    modport slave (
        input  valid,
        input  addr,
        input  tag,
        output ready
    );

endinterface

`endif
