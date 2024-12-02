// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch
// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module l2_shared_cache
(
    input logic clk_i,
    input logic rst_ni,

    VX_cache_req_if.slave  l2_cache_req,
    VX_cache_rsp_if.master l2_cache_rsp,

    obi_req_if.master host_req,
    obi_rsp_if.slave  host_rsp
);

    VX_mem_req_if #(
        .DATA_WIDTH (`L2_MEM_DATA_WIDTH),
        .ADDR_WIDTH (`L2_MEM_ADDR_WIDTH),
        .TAG_WIDTH  (`L2_MEM_TAG_WIDTH)
    ) bus_adapter_req();

    VX_mem_rsp_if #(
        .DATA_WIDTH (`L2_MEM_DATA_WIDTH),
        .TAG_WIDTH  (`L2_MEM_TAG_WIDTH)
    ) bus_adapter_rsp();


    l2_cache l2_cache (
        .clk_i           (clk_i),
        .rst_ni          (rst_ni),
        .l2_cache_req    (l2_cache_req),
        .l2_cache_rsp    (l2_cache_rsp),
        .bus_adapter_req (bus_adapter_req),
        .bus_adapter_rsp (bus_adapter_rsp)
    );

    bus_adapter bus_adapter (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .serial_req (bus_adapter_req),
        .serial_rsp (bus_adapter_rsp),
        .host_req   (host_req),
        .host_rsp   (host_rsp)
    );

endmodule
