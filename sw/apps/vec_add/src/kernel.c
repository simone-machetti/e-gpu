// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

#include <stdio.h>
#include <vx_intrinsics.h>
#include "e_gpu_scheduler.h"

void main()
{
  schedule_kernel(&kernel_args);

  kernel_args.done[vx_core_id()] = 1;

  while(1);
}

void __attribute__ ((noinline)) kernel(unsigned int task_id)
{
  unsigned int *src_a_ptr = (unsigned int *)kernel_args.args[0];
  unsigned int *src_b_ptr = (unsigned int *)kernel_args.args[1];
  unsigned int *dst_c_ptr = (unsigned int *)kernel_args.args[2];

  dst_c_ptr[task_id] = src_a_ptr[task_id] + src_b_ptr[task_id];
}
