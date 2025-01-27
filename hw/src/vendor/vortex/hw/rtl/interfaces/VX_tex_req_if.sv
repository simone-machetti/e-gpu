`ifndef VX_TEX_REQ_IF
`define VX_TEX_REQ_IF

`include "VX_define.vh"

interface VX_tex_req_if ();

    logic                               valid;
    logic [`UUID_BITS-1:0]              uuid;
    logic [`NW_BITS-1:0]                wid;
    logic [`NUM_THREADS-1:0]            tmask;
    logic [31:0]                        PC;
    logic [`NR_BITS-1:0]                rd;
    logic                               wb;

    logic [`NTEX_BITS-1:0]              unit;
    logic [1:0][`NUM_THREADS-1:0][31:0] coords;
    logic [`NUM_THREADS-1:0][31:0]      lod;

    logic                               ready;

    modport master (
        output valid,
        output uuid,
        output wid,
        output tmask,
        output PC,
        output rd,
        output wb,
        output unit,
        output coords,
        output lod,
        input  ready
    );

    modport slave (
        input  valid,
        input  uuid,
        input  wid,
        input  tmask,
        input  PC,
        input  rd,
        input  wb,
        input  unit,
        input  coords,
        input  lod,
        output ready
    );

endinterface
`endif
