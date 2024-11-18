// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

#include <stdio.h>
#include "e_gpu_scheduler.h"

#define LENGTH 16

volatile unsigned int vec_a[LENGTH];
volatile unsigned int vec_b[LENGTH];
volatile unsigned int vec_c[LENGTH];
volatile unsigned int vec_res[LENGTH];

void __attribute__ ((noinline)) init_arrays()
{
  for (int i=0; i<LENGTH; i++)
  {
    vec_a[i] = i;
    vec_b[i] = i;
    vec_c[i] = 0;
    vec_res[i] = i * i;
  }
}

void __attribute__ ((noinline)) init_kernel()
{
  kernel_args.num_tasks = LENGTH;
  kernel_args.ptr       = &kernel;
  kernel_args.args[0]   = vec_a;
  kernel_args.args[1]   = vec_b;
  kernel_args.args[2]   = vec_c;
  kernel_args.args[3]   = vec_res;
}

void __attribute__ ((noinline)) check_kernel()
{
  unsigned int *dst_c_ptr = (unsigned int *)kernel_args.args[2];
  unsigned int *res_ptr   = (unsigned int *)kernel_args.args[3];

  for (int i=0; i<LENGTH; i++)
  {
    if (dst_c_ptr[i] != res_ptr[i])
    {
      kernel_args.done = 2;
      while(1);
    }
  }

  kernel_args.done = 1;
  while(1);
}

void main()
{
  init_arrays();

  init_kernel();

  schedule_kernel(&kernel_args);

  check_kernel();

  while(1);
}

void __attribute__ ((noinline)) kernel(unsigned int task_id)
{
  unsigned int *src_a_ptr = (unsigned int *)kernel_args.args[0];
  unsigned int *src_b_ptr = (unsigned int *)kernel_args.args[1];
  unsigned int *dst_c_ptr = (unsigned int *)kernel_args.args[2];

  dst_c_ptr[task_id] = src_a_ptr[task_id] * src_b_ptr[task_id];
}
