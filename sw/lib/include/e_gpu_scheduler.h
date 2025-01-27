// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

#ifndef _E_GPU_SCHEDULER_H_
#define _E_GPU_SCHEDULER_H_

#define NUM_COMPUTE_UNITS   2
#define MAX_NUM_ARGS_KERNEL 64

typedef struct {
  volatile unsigned int global_work_size;
  volatile unsigned int local_work_size;
  volatile unsigned int *args[MAX_NUM_ARGS_KERNEL];
} kernel_args_t;

extern kernel_args_t kernel_args;

__attribute__ ((noinline)) void schedule_kernel(kernel_args_t *kernel_args);
__attribute__ ((noinline)) void kernel(unsigned int task_id);

#endif
