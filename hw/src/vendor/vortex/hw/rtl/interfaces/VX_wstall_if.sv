`ifndef VX_WSTALL_IF
`define VX_WSTALL_IF

`include "VX_define.vh"

interface VX_wstall_if();

    logic                valid;
    logic [`NW_BITS-1:0] wid;
    logic                stalled;

    modport master (
        output valid,
        output wid,
        output stalled
    );

    modport slave (
        input valid,
        input wid,
        input stalled
    );

endinterface

`endif
