// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`define IN_FILE  "$E_GPU_HOME/hw/imp/sim/input/kernel.mem"
`define OUT_FILE "$E_GPU_HOME/hw/imp/sim/output/output.mem"

`define HOST_MEM_SIZE        32'h00020000
`define HOST_MEM_KERNEL_ARGS 32'h00010000
`define HOST_MEM_KERNEL_DATA 32'h00018000

`define HOST_MEM_SIZE_WORD        (`HOST_MEM_SIZE / 4)
`define HOST_MEM_KERNEL_ARGS_WORD (`HOST_MEM_KERNEL_ARGS / 4)
`define HOST_MEM_KERNEL_DATA_WORD (`HOST_MEM_KERNEL_DATA / 4)

module testbench;

    logic clk;
    logic rst_n;

    obi_req_if host_mem_req();
    obi_rsp_if host_mem_rsp();

    obi_req_if conf_regs_req();
    obi_rsp_if conf_regs_rsp();

    real clk_period = 100;

    e_gpu e_gpu_i (
        .clk_i         (clk),
        .rst_ni        (rst_n),
        .conf_regs_req (conf_regs_req),
        .conf_regs_rsp (conf_regs_rsp),
        .host_mem_req  (host_mem_req),
        .host_mem_rsp  (host_mem_rsp)
    );

    host_mem #(
        .MEM_SIZE_WORD (`HOST_MEM_SIZE_WORD)
    ) host_mem_i (
        .clk_i         (clk),
        .rst_ni        (rst_n),
        .host_mem_req  (host_mem_req),
        .host_mem_rsp  (host_mem_rsp)
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
        int unsigned i;
        for (i=0; i<`HOST_MEM_SIZE_WORD; i++) begin
            testbench.host_mem_i.mem_array[i] = 0;
        end

        $readmemh(`IN_FILE, testbench.host_mem_i.mem_array);
    end
    endtask

    task dump_mem;
    begin
        int unsigned fd;
        int unsigned i;
        fd = $fopen(`OUT_FILE, "w");
        for (i = 0; i < `HOST_MEM_SIZE_WORD; i++) begin
            $fdisplay(fd, "%X", testbench.host_mem_i.mem_array[i]);
        end
    end
    endtask

    task write_kernel_args (input logic [31:0] addr_offset, input logic [31:0] data);
    begin
        testbench.host_mem_i.mem_array[`HOST_MEM_KERNEL_ARGS_WORD + (addr_offset / 4)] = data;
    end
    endtask

    task read_kernel_args (input logic [31:0] addr_offset, output logic [31:0] data);
    begin
        data = testbench.host_mem_i.mem_array[`HOST_MEM_KERNEL_ARGS_WORD + (addr_offset / 4)];
    end
    endtask

    task write_kernel_data (input logic [31:0] addr_offset, input logic [31:0] data);
    begin
        testbench.host_mem_i.mem_array[`HOST_MEM_KERNEL_DATA_WORD + (addr_offset / 4)] = data;
    end
    endtask

    task read_kernel_data (input logic [31:0] addr_offset, output logic [31:0] data);
    begin
        data = testbench.host_mem_i.mem_array[`HOST_MEM_KERNEL_DATA_WORD + (addr_offset / 4)];
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

    `include "host.vh"

    initial begin
        rst_n = 1'b0;
        init_vcd;
        init_mem;
        write_data;
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

        if((testbench.host_mem_i.mem_array[`HOST_MEM_KERNEL_ARGS_WORD] == 1) && (testbench.host_mem_i.mem_array[`HOST_MEM_KERNEL_ARGS_WORD + 1] == 1)) begin
            stop_vcd;
            dump_mem;
            check_results;
            $stop;
        end
    end

endmodule
