// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

#ifndef _E_GPU_SCHEDULER_H_
#define _E_GPU_SCHEDULER_H_

#define MAX_NUM_ARGS_KERNEL 64

typedef struct {
  volatile unsigned int done;
  volatile unsigned int num_tasks;
  volatile void (*ptr)(unsigned int);
  volatile unsigned int *args[MAX_NUM_ARGS_KERNEL];
} kernel_args_t;

extern kernel_args_t kernel_args;

void __attribute__ ((noinline)) schedule_kernel(kernel_args_t *kernel_args);
void __attribute__ ((noinline)) kernel(unsigned int task_id);

#endif
