`ifndef VX_IFETCH_RSP_IF
`define VX_IFETCH_RSP_IF

`include "VX_define.vh"

interface VX_ifetch_rsp_if ();

    logic                    valid;
    logic [`UUID_BITS-1:0]   uuid;
    logic [`NUM_THREADS-1:0] tmask;
    logic [`NW_BITS-1:0]     wid;
    logic [31:0]             PC;
    logic [31:0]             data;
    logic                    ready;

    modport master (
        output valid,
        output uuid,
        output tmask,
        output wid,
        output PC,
        output data,
        input  ready
    );

    modport slave (
        input  valid,
        input  uuid,
        input  tmask,
        input  wid,
        input  PC,
        input  data,
        output ready
    );

endinterface

`endif
