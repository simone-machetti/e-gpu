`ifndef VX_IFETCH_REQ_IF
`define VX_IFETCH_REQ_IF

`include "VX_define.vh"

interface VX_ifetch_req_if ();

    logic                    valid;
    logic [`UUID_BITS-1:0]   uuid;
    logic [`NUM_THREADS-1:0] tmask;
    logic [`NW_BITS-1:0]     wid;
    logic [31:0]             PC;
    logic                    ready;

    modport master (
        output valid,
        output uuid,
        output tmask,
        output wid,
        output PC,
        input  ready
    );

    modport slave (
        input  valid,
        input  uuid,
        input  tmask,
        input  wid,
        input  PC,
        output ready
    );

endinterface

`endif
