// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

#include <VX_config.h>

.section .start, "ax"
.global _start
.set _STACK_SIZE, 0x8000

_start:

    csrr a0, CSR_NW            # a0 <-- warp_num
    la a1, _init_regs          # a1 <-- &init_regs
    .insn s 0x6b, 1, a1, 0(a0) # activate all warps
    jal _init_regs             # jamp to init_regs
    li a0, 1                   # a0 <-- 1
    .insn s 0x6b, 0, x0, 0(a0) # disactivate all threads but 0

    call main                  # call main
    .insn i 0x6b, 6, x0, x0, 0 # generate a sleep event
    j _loop                    # jump to _loop

_loop:

    j _loop                    # infinite loop

_init_regs:

    li a0, -1                  # a0 <-- -1
    .insn s 0x6b, 0, x0, 0(a0) # activate all threads

    csrr a0, CSR_NC            # a0 <-- compute_unit_num
    csrr a1, CSR_GCID          # a1 <-- compute_unit_id
    csrr a2, CSR_NW            # a2 <-- warp_num
    csrr a3, CSR_LWID          # a3 <-- warp_id
    csrr a4, CSR_NT            # a4 <-- thread_num
    csrr a5, CSR_WTID          # a5 <-- thread_id

    mul a6, a0, a2             # a6 <-- compute_unit_num x warp_num
    mul a6, a6, a4             # a6 <-- (compute_unit_num x warp_num) x thread_num = stack_num

    li a7, _STACK_SIZE         # a7 <-- __STACK_SIZE
    div a7, a7, a6             # a7 <-- __STACK_SIZE / stack_num      = stack_per_thread
    mul a0, a7, a4             # a0 <-- stack_per_thread x thread_num = stack_per_warp
    mul a2, a0, a2             # a2 <-- stack_per_warp x warp_num     = stack_per_compute_unit

    mul a7, a7, a5             # a7 <-- stack_per_thread x thread_id
    mul a0, a0, a3             # a6 <-- stack_per_warp x warp_id
    mul a2, a2, a1             # a4 <-- stack_per_compute_unit x compute_unit_id

    la a1, __stack             # a1 <-- __stack
    sub a1, a1, a2             # a1 <-- __stack - (stack_per_compute_unit x compute_unit_id)
    sub a1, a1, a0             # a1 <-- __stack - (stack_per_compute_unit x compute_unit_id) - (stack_per_warp x warp_id)
    sub a1, a1, a7             # a1 <-- __stack - (stack_per_compute_unit x compute_unit_id) - (stack_per_warp x warp_id) - (stack_per_thread x thread_id) = stack_pointer

    mv sp, a1                  # sp <-- stack_pointer

    beqz a3, _end              # if (warp_id == 0) {PC <-- _end}
    li a0, 0                   # a4 <-- ZERO
    .insn s 0x6b, 0, x0, 0(a0) # disactivate all warps but 0

_end:

    ret                        # return
