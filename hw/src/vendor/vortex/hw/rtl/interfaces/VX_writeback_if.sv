`ifndef VX_WRITEBACK_IF
`define VX_WRITEBACK_IF

`include "VX_define.vh"

interface VX_writeback_if ();

    logic                          valid;
    logic [`UUID_BITS-1:0]         uuid;
    logic [`NUM_THREADS-1:0]       tmask;
    logic [`NW_BITS-1:0]           wid;
    logic [31:0]                   PC;
    logic [`NR_BITS-1:0]           rd;
    logic [`NUM_THREADS-1:0][31:0] data;
    logic                          eop;
    logic                          ready;

    modport master (
        output valid,
        output uuid,
        output tmask,
        output wid,
        output PC,
        output rd,
        output data,
        output eop,
        input  ready
    );

    modport slave (
        input  valid,
        input  uuid,
        input  tmask,
        input  wid,
        input  PC,
        input  rd,
        input  data,
        input  eop,
        output ready
    );

endinterface

`endif
