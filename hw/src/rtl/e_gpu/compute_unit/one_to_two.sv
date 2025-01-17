// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

`include "e_gpu.vh"

module one_to_two
    import mem_map_pkg::*;
#(
    parameter NUM_REQS = 4
)(
    input logic clk_i,
    input logic rst_ni,

    VX_dcache_req_if.master pipeline_req,
    VX_dcache_rsp_if.slave  pipeline_rsp,

    VX_dcache_req_if.master local_mem_req,
    VX_dcache_rsp_if.slave  local_mem_rsp,

    VX_dcache_req_if.master l1_cache_req,
    VX_dcache_rsp_if.slave  l1_cache_rsp
);

    /*
    * Requests: pipeline --> local memory or L1 cache
    */
    always_comb begin

        for (int req = 0; req < NUM_REQS; req++) begin : gen_mux_demux_req

            local_mem_req.valid[req]  = '0;
            local_mem_req.rw[req]     = '0;
            local_mem_req.byteen[req] = '0;
            local_mem_req.addr[req]   = '0;
            local_mem_req.data[req]   = '0;
            local_mem_req.tag[req]    = '0;

            l1_cache_req.valid[req]   = '0;
            l1_cache_req.rw[req]      = '0;
            l1_cache_req.byteen[req]  = '0;
            l1_cache_req.addr[req]    = '0;
            l1_cache_req.data[req]    = '0;
            l1_cache_req.tag[req]     = '0;

            if (pipeline_req.addr[req] >= (mem_map_pkg::LOCAL_MEM_START_ADDRESS >> 2) && pipeline_req.addr[req] < (mem_map_pkg::LOCAL_MEM_END_ADDRESS >> 2)) begin

                local_mem_req.valid[req]  = pipeline_req.valid[req];
                local_mem_req.rw[req]     = pipeline_req.rw[req];
                local_mem_req.byteen[req] = pipeline_req.byteen[req];
                local_mem_req.addr[req]   = pipeline_req.addr[req];
                local_mem_req.data[req]   = pipeline_req.data[req];
                local_mem_req.tag[req]    = pipeline_req.tag[req];

                pipeline_req.ready[req]   = local_mem_req.ready[req];

            end
            else begin

                l1_cache_req.valid[req]   = pipeline_req.valid[req];
                l1_cache_req.rw[req]      = pipeline_req.rw[req];
                l1_cache_req.byteen[req]  = pipeline_req.byteen[req];
                l1_cache_req.addr[req]    = pipeline_req.addr[req];
                l1_cache_req.data[req]    = pipeline_req.data[req];
                l1_cache_req.tag[req]     = pipeline_req.tag[req];

                pipeline_req.ready[req]   = l1_cache_req.ready[req];

            end

        end

    end

    /*
    * Responses: local memory or L1 cache --> pipeline
    */
    always_comb begin

        local_mem_rsp.ready = 1'b0;
        l1_cache_rsp.ready  = 1'b0;

        if (local_mem_rsp.valid) begin

            pipeline_rsp.valid  = local_mem_rsp.valid;
            pipeline_rsp.tag    = local_mem_rsp.tag;
            local_mem_rsp.ready = pipeline_rsp.ready;

            for (int req = 0; req < NUM_REQS ; req++) begin : gen_mux_demux_rsp_0

                pipeline_rsp.tmask[req] = local_mem_rsp.tmask[req];
                pipeline_rsp.data[req]  = local_mem_rsp.data[req];

            end

        end
        else begin

            pipeline_rsp.valid = l1_cache_rsp.valid;
            pipeline_rsp.tag   = l1_cache_rsp.tag;
            l1_cache_rsp.ready = pipeline_rsp.ready;

            for (int req = 0; req < NUM_REQS; req++) begin : gen_mux_demux_rsp_1

                pipeline_rsp.tmask[req] = l1_cache_rsp.tmask[req];
                pipeline_rsp.data[req]  = l1_cache_rsp.data[req];

            end

        end

    end

endmodule
