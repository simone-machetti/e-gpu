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
    .insn s 0x6b, 0, x0, 0(a0) # disactivate all warps but 0

    call main                  # call main
    j _loop                    # jump to _loop

_loop:

    j _loop                    # infinite loop

_init_regs:

    li a0, -1                  # a0 <-- -1
    .insn s 0x6b, 0, x0, 0(a0) # activate all threads

    csrr a0, CSR_NW            # a0 <-- warp_num
    csrr a1, CSR_LWID          # a1 <-- warp_id
    csrr a2, CSR_NT            # a2 <-- thread_num
    csrr a3, CSR_WTID          # a3 <-- thread_id

    li a4, _STACK_SIZE         # a4 <-- __stack_size
    mul a5, a0, a2             # a5 <-- warp_num x thread_num
    div a4, a4, a5             # a5 <-- __stack_size / (warp_num x thread_num)

    mul a5, a2, a4             # a5 <-- thread_num x stack_per_thread
    mul a5, a5, a1             # a5 <-- (thread_num x stack_per_thread) x warp_id
    mul a6, a3, a4             # a6 <-- thread_id x stack_per_thread

    la a4, __stack             # a4 <-- __stack

    sub a4, a4, a5             # a4 <-- __stack - ((thread_num x stack_per_thread) x warp_id)
    sub a4, a4, a6             # a4 <-- __stack - ((thread_num x stack_per_thread) x warp_id) - (thread_id x stack_per_thread)
    mv sp, a4                  # sp <-- __stack - ((thread_num x stack_per_thread) x warp_id) - (thread_id x stack_per_thread)

    beqz a1, _end              # if (a1 == 0) {PC <-- _end}
    li a4, 0                   # a4 <-- ZERO
    .insn s 0x6b, 0, x0, 0(a4) # disactivate all threads but 0

_end:

    ret                        # return
