`ifndef VX_DCACHE_REQ_IF
`define VX_DCACHE_REQ_IF

`include "../cache/VX_cache_define.vh"

interface VX_dcache_req_if #(
    parameter NUM_REQS  = 1,
    parameter WORD_SIZE = 1,
    parameter TAG_WIDTH = 1
) ();

    logic [NUM_REQS-1:0]                       valid;
    logic [NUM_REQS-1:0]                       rw;
    logic [NUM_REQS-1:0][WORD_SIZE-1:0]        byteen;
    logic [NUM_REQS-1:0][`WORD_ADDR_WIDTH-1:0] addr;
    logic [NUM_REQS-1:0][`WORD_WIDTH-1:0]      data;
    logic [NUM_REQS-1:0][TAG_WIDTH-1:0]        tag;
    logic [NUM_REQS-1:0]                       ready;

    modport master (
        output valid,
        output rw,
        output byteen,
        output addr,
        output data,
        output tag,
        input  ready
    );

    modport slave (
        input  valid,
        input  rw,
        input  byteen,
        input  addr,
        input  data,
        input  tag,
        output ready
    );

endinterface

`endif
