`ifndef VX_DECODE_IF
`define VX_DECODE_IF

`include "VX_define.vh"

interface VX_decode_if ();

    logic                      valid;
    logic [`UUID_BITS-1:0]     uuid;
    logic [`NW_BITS-1:0]       wid;
    logic [`NUM_THREADS-1:0]   tmask;
    logic [31:0]               PC;
    logic [`EX_BITS-1:0]       ex_type;
    logic [`INST_OP_BITS-1:0]  op_type;
    logic [`INST_MOD_BITS-1:0] op_mod;
    logic                      wb;
    logic                      use_PC;
    logic                      use_imm;
    logic [31:0]               imm;
    logic [`NR_BITS-1:0]       rd;
    logic [`NR_BITS-1:0]       rs1;
    logic [`NR_BITS-1:0]       rs2;
    logic [`NR_BITS-1:0]       rs3;
    logic                      ready;

    modport master (
        output valid,
        output uuid,
        output wid,
        output tmask,
        output PC,
        output ex_type,
        output op_type,
        output op_mod,
        output wb,
        output use_PC,
        output use_imm,
        output imm,
        output rd,
        output rs1,
        output rs2,
        output rs3,
        input  ready
    );

    modport slave (
        input  valid,
        input  uuid,
        input  wid,
        input  tmask,
        input  PC,
        input  ex_type,
        input  op_type,
        input  op_mod,
        input  wb,
        input  use_PC,
        input  use_imm,
        input  imm,
        input  rd,
        input  rs1,
        input  rs2,
        input  rs3,
        output ready
    );

endinterface

`endif
