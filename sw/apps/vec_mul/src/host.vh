// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`ifndef HOST
`define HOST

`define NUM_TASKS 188

`define ARRAY_SIZE (`NUM_TASKS * 4)

`define ARRAY_A_OFFSET 0
`define ARRAY_B_OFFSET `ARRAY_SIZE
`define ARRAY_C_OFFSET (`ARRAY_SIZE * 2)
`define EXPECTED_RESULT 50

task write_data;
begin
    int unsigned i;
    for (i = 0; i < `ARRAY_SIZE; i += 4) begin
        write_kernel_data(`ARRAY_A_OFFSET + i, 5);
        write_kernel_data(`ARRAY_B_OFFSET + i, 10);
        write_kernel_data(`ARRAY_C_OFFSET + i, 0);
    end

    write_kernel_args(32'h08, `NUM_TASKS);
    write_kernel_args(32'h0C, `HOST_MEM_KERNEL_DATA + `ARRAY_A_OFFSET);
    write_kernel_args(32'h10, `HOST_MEM_KERNEL_DATA + `ARRAY_B_OFFSET);
    write_kernel_args(32'h14, `HOST_MEM_KERNEL_DATA + `ARRAY_C_OFFSET);
end
endtask

task check_results;
begin
    int unsigned i;
    logic [31:0] data;
    for (i = 0; i < `ARRAY_SIZE; i += 4) begin
        read_kernel_data(`ARRAY_C_OFFSET + i, data);
        if (data != `EXPECTED_RESULT) begin
            $display("Error! Address: 0x%X - Read data: 0x%X - Expected data: 0x%X", (`HOST_MEM_KERNEL_DATA + `ARRAY_C_OFFSET + i), data, `EXPECTED_RESULT);
            $stop;
        end
    end
    $display("Passed!");
end
endtask

`endif
