// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

#include <stdio.h>
#include <vx_intrinsics.h>
#include "gpu_scheduler.h"

typedef struct {
  volatile unsigned int done;
  volatile unsigned int global_id;
  volatile unsigned int active_warps;
  volatile unsigned int active_threads;
  volatile kernel_args_t *kernel_args;
} tasks_args_t;

void __attribute__ ((noinline)) spawn_warps(void);
void __attribute__ ((noinline)) spawn_threads(void);
void __attribute__ ((noinline)) spawn_tasks(void);

tasks_args_t tasks_args;

__attribute__((section(".args"))) kernel_args_t kernel_args;

void __attribute__ ((noinline)) schedule_kernel(kernel_args_t *kernel_args)
{
  tasks_args.kernel_args = kernel_args;
  spawn_warps();
}

void __attribute__ ((noinline)) spawn_warps()
{
  unsigned int num_tasks        = (unsigned int) tasks_args.kernel_args->num_tasks;
  unsigned int warps_per_core   = vx_num_warps();
  unsigned int threads_per_warp = vx_num_threads();
  unsigned int threads_per_core = warps_per_core * threads_per_warp;

  unsigned int needed_threads   = num_tasks;
  unsigned int needed_warps     = needed_threads / threads_per_warp;
  unsigned int needed_cores     = needed_threads / threads_per_core;

  if (needed_cores != 0)
  {
    tasks_args.global_id      = 0;
    tasks_args.active_threads = threads_per_warp;
    tasks_args.active_warps   = warps_per_core;

    for (int i=0; i<needed_cores; i++)
    {
      vx_wspawn(warps_per_core, spawn_threads);
      spawn_threads();
      tasks_args.global_id = tasks_args.global_id + threads_per_core;
    }
  }

  needed_threads = needed_threads - (needed_cores * threads_per_core);
  needed_warps   = needed_threads / threads_per_warp;

  if (needed_warps != 0)
  {
    tasks_args.active_threads = threads_per_warp;
    tasks_args.active_warps   = needed_warps;

    vx_wspawn(needed_warps, spawn_threads);
    spawn_threads();
    tasks_args.global_id = tasks_args.global_id + (needed_warps * threads_per_warp);
  }

  needed_threads = needed_threads - (needed_warps * threads_per_warp);

  if (needed_threads != 0)
  {
    tasks_args.active_threads = needed_threads;
    tasks_args.active_warps   = 1;
    spawn_threads();
  }
}

void __attribute__ ((noinline)) spawn_threads()
{
  vx_tmc((1 << tasks_args.active_threads) - 1);
  spawn_tasks();

  int warp_id = vx_warp_id();
  vx_tmc(0 == warp_id);
}

void __attribute__ ((noinline)) spawn_tasks()
{
  unsigned int thread_id        = vx_thread_id();
  unsigned int warp_id          = vx_warp_id();
  unsigned int threads_per_warp = vx_num_threads();
  unsigned int warps_per_core   = vx_num_warps();

  unsigned int task_id = tasks_args.global_id + (warp_id * threads_per_warp) + thread_id;

  tasks_args.kernel_args->ptr(task_id);

  vx_barrier(0, tasks_args.active_warps);
}
