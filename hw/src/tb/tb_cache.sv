// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`define RAM_SIZE_BYTE 163840 // I: 32KB + D: 4 x 32KB = 160KB
`define RAM_DONE_WORD 40704

`define IN_FILE  "$E_GPU_HOME/hw/imp/sim/input/kernel.mem"

module testbench;

    logic clk;
    logic rst_n;

    obi_req_if instr_mem_req();
    obi_rsp_if instr_mem_rsp();

    obi_req_if data_mem_req();
    obi_rsp_if data_mem_rsp();

    obi_req_if conf_regs_req();
    obi_rsp_if conf_regs_rsp();

    real clk_period = 100;

    e_gpu_top e_gpu_top_i (
        .clk_i         (clk),
        .rst_ni        (rst_n),
        .conf_regs_req (conf_regs_req),
        .conf_regs_rsp (conf_regs_rsp),
        .instr_mem_req (instr_mem_req),
        .instr_mem_rsp (instr_mem_rsp),
        .data_mem_req  (data_mem_req),
        .data_mem_rsp  (data_mem_rsp)
    );

    dual_port_ram # (
        .MEM_SIZE_WORD (`RAM_SIZE_BYTE/4)
    ) dual_port_ram_i (
        .clk_i         (clk),
        .rst_ni        (rst_n),
        .instr_mem_req (instr_mem_req),
        .instr_mem_rsp (instr_mem_rsp),
        .data_mem_req  (data_mem_req),
        .data_mem_rsp  (data_mem_rsp)
    );

    task init_vcd;
    begin
        $dumpfile("output.vcd");
    end
    endtask

    task start_vcd;
    begin
        $dumpvars(0, testbench);
    end
    endtask

    task stop_vcd;
    begin
        $dumpoff;
    end
    endtask

    task init_mem;
    begin
        int i;
        for (i=0; i<`RAM_SIZE_BYTE/4; i++) begin
            testbench.dual_port_ram_i.mem_array[i] = 0;
        end
        $readmemh(`IN_FILE, testbench.dual_port_ram_i.mem_array);
    end
    endtask

    task write_conf_regs (input logic [31:0] addr, input logic [31:0] data);
    begin
        @(posedge clk);
        conf_regs_req.req   = 1'b1;
        conf_regs_req.we    = 1'b1;
        conf_regs_req.be    = 4'b1111;
        conf_regs_req.addr  = addr;
        conf_regs_req.wdata = data;

        while (!conf_regs_req.gnt)
            @(posedge clk);

        conf_regs_req.req = 1'b0;

        while (!conf_regs_rsp.rvalid);
            @(posedge clk);
    end
    endtask

    initial begin
        rst_n = 1'b0;
        init_vcd;
        init_mem;
        start_vcd;
        #(clk_period*50);
        rst_n = 1'b1;
        write_conf_regs(32'd0, 32'd1);
        #(clk_period*50);
        write_conf_regs(32'd4, 32'd1);
    end

    always begin
        clk = 1'b0;
        #(clk_period/2);
        clk = 1'b1;
        #(clk_period/2);

        if(testbench.dual_port_ram_i.mem_array[`RAM_DONE_WORD][31:0] == 1) begin
            stop_vcd;
            $stop;
        end
    end

endmodule
