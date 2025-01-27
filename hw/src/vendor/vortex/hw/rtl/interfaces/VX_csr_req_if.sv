`ifndef VX_CSR_REQ_IF
`define VX_CSR_REQ_IF

`include "VX_define.vh"

interface VX_csr_req_if ();

    logic                      valid;
    logic [`UUID_BITS-1:0]     uuid;
    logic [`NW_BITS-1:0]       wid;
    logic [`NUM_THREADS-1:0]   tmask;
    logic [31:0]               PC;
    logic [`INST_CSR_BITS-1:0] op_type;
    logic [`CSR_ADDR_BITS-1:0] addr;
    logic [31:0]               rs1_data;
    logic                      use_imm;
    logic [`NRI_BITS-1:0]      imm;
    logic [`NR_BITS-1:0]       rd;
    logic                      wb;
    logic                      ready;

    modport master (
        output valid,
        output uuid,
        output wid,
        output tmask,
        output PC,
        output op_type,
        output addr,
        output rs1_data,
        output use_imm,
        output imm,
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
        input  op_type,
        input  addr,
        input  rs1_data,
        input  use_imm,
        input  imm,
        input  rd,
        input  wb,
        output ready
    );

endinterface

`endif
