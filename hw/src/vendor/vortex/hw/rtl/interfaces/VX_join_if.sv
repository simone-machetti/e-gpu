`ifndef VX_JOIN_IF
`define VX_JOIN_IF

`include "VX_define.vh"

interface VX_join_if ();

    logic                valid;
    logic [`NW_BITS-1:0] wid;

    modport master (
        output valid,
        output wid
    );

    modport slave (
        input valid,
        input wid
    );

endinterface

`endif
