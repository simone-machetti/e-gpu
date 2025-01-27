`ifndef VX_GPU_REQ_IF
`define VX_GPU_REQ_IF

`include "VX_define.vh"

interface VX_gpu_req_if();

    logic                          valid;
    logic [`UUID_BITS-1:0]         uuid;
    logic [`NW_BITS-1:0]           wid;
    logic [`NUM_THREADS-1:0]       tmask;
    logic [31:0]                   PC;
    logic [31:0]                   next_PC;
    logic [`INST_GPU_BITS-1:0]     op_type;
    logic [`INST_MOD_BITS-1:0]     op_mod;
    logic [`NT_BITS-1:0]           tid;
    logic [`NUM_THREADS-1:0][31:0] rs1_data;
    logic [`NUM_THREADS-1:0][31:0] rs2_data;
    logic [`NUM_THREADS-1:0][31:0] rs3_data;
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
        output tid,
        output rs1_data,
        output rs2_data,
        output rs3_data,
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
        input  tid,
        input  rs1_data,
        input  rs2_data,
        input  rs3_data,
        input  rd,
        input  wb,
        output ready
    );

endinterface

`endif
