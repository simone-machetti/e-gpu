`ifndef VX_GPR_REQ_IF
`define VX_GPR_REQ_IF

`include "VX_define.vh"

interface VX_gpr_req_if ();

    logic [`NW_BITS-1:0] wid;
    logic [`NR_BITS-1:0] rs1;
    logic [`NR_BITS-1:0] rs2;
    logic [`NR_BITS-1:0] rs3;

    modport master (
        output wid,
        output rs1,
        output rs2,
        output rs3
    );

    modport slave (
        input wid,
        input rs1,
        input rs2,
        input rs3
    );

endinterface

`endif
