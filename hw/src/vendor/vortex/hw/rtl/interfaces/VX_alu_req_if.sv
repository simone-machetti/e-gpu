`ifndef VX_ALU_REQ_IF
`define VX_ALU_REQ_IF

`include "VX_define.vh"

interface VX_alu_req_if ();

    logic                          valid;
    logic [`UUID_BITS-1:0]         uuid;
    logic [`NW_BITS-1:0]           wid;
    logic [`NUM_THREADS-1:0]       tmask;
    logic [31:0]                   PC;
    logic [31:0]                   next_PC;
    logic [`INST_ALU_BITS-1:0]     op_type;
    logic [`INST_MOD_BITS-1:0]     op_mod;
    logic                          use_PC;
    logic                          use_imm;
    logic [31:0]                   imm;
    logic [`NT_BITS-1:0]           tid;
    logic [`NUM_THREADS-1:0][31:0] rs1_data;
    logic [`NUM_THREADS-1:0][31:0] rs2_data;
    logic [`NR_BITS-1:0]           rd;
    logic                          wb;
    logic                          ready;

    modport master (
        output valid,
        output uuid,
        output wid,
        output tmask,
        output PC,
        output next_PC,
        output op_type,
        output op_mod,
        output use_PC,
        output use_imm,
        output imm,
        output tid,
        output rs1_data,
        output rs2_data,
        output rd,
        output wb,
        input  ready
    );

    modport slave (
        input  valid,
        input  uuid,
        input  wid,
        input  tmask,
        input  PC,
        input  next_PC,
        input  op_type,
        input  op_mod,
        input  use_PC,
        input  use_imm,
        input  imm,
        input  tid,
        input  rs1_data,
        input  rs2_data,
        input  rd,
        input  wb,
        output ready
    );

endinterface

`endif
