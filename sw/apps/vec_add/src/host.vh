// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`ifndef HOST
`define HOST

`define LOCAL_WORK_SIZE  64
`define NUM_WORK_GROUPS  4

`define GLOBAL_WORK_SIZE (`LOCAL_WORK_SIZE * `NUM_WORK_GROUPS)
`define ARRAY_SIZE       (`GLOBAL_WORK_SIZE * 4)
`define ARRAY_A_OFFSET   0
`define ARRAY_B_OFFSET   `ARRAY_SIZE
`define ARRAY_C_OFFSET   (`ARRAY_SIZE * 2)
`define EXPECTED_RESULT  15

task write_data;
begin
    int unsigned i;
    for (i = 0; i < `ARRAY_SIZE; i += 4) begin
        write_kernel_data(`ARRAY_A_OFFSET + i, 5);
        write_kernel_data(`ARRAY_B_OFFSET + i, 10);
        write_kernel_data(`ARRAY_C_OFFSET + i, 0);
    end

    write_kernel_args(32'h0,  `GLOBAL_WORK_SIZE);
    write_kernel_args(32'h4,  `LOCAL_WORK_SIZE);
    write_kernel_args(32'h8,  `HOST_MEM_KERNEL_DATA + `ARRAY_A_OFFSET);
    write_kernel_args(32'hC,  `HOST_MEM_KERNEL_DATA + `ARRAY_B_OFFSET);
    write_kernel_args(32'h10, `HOST_MEM_KERNEL_DATA + `ARRAY_C_OFFSET);
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
