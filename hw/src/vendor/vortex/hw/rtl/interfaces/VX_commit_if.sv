`ifndef VX_COMMIT_IF
`define VX_COMMIT_IF

`include "VX_define.vh"

interface VX_commit_if ();

    logic                          valid;
    logic [`UUID_BITS-1:0]         uuid;
    logic [`NW_BITS-1:0]           wid;
    logic [`NUM_THREADS-1:0]       tmask;
    logic [31:0]                   PC;
    logic [`NUM_THREADS-1:0][31:0] data;
    logic [`NR_BITS-1:0]           rd;
    logic                          wb;
    logic                          eop;
    logic                          ready;

    modport master (
        output valid,
        output uuid,
        output wid,
        output tmask,
        output PC,
        output data,
        output rd,
        output wb,
        output eop,
        input  ready
    );

    modport slave (
        input  valid,
        input  uuid,
        input  wid,
        input  tmask,
        input  PC,
        input  data,
        input  rd,
        input  wb,
        input  eop,
        output ready
    );

endinterface

`endif
