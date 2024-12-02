// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Author: Simone Machetti - simone.machetti@epfl.ch

#include <stdio.h>
#include <vx_intrinsics.h>
#include "e_gpu_scheduler.h"

typedef struct {
  volatile unsigned int global_id[NUM_COMPUTE_UNITS];
  volatile unsigned int active_warps[NUM_COMPUTE_UNITS];
  volatile unsigned int active_threads[NUM_COMPUTE_UNITS];
  volatile kernel_args_t *kernel_args;
} tasks_args_t;

void __attribute__ ((noinline)) spawn_warps(void);
void __attribute__ ((noinline)) spawn_threads(void);
void __attribute__ ((noinline)) spawn_tasks(void);

tasks_args_t tasks_args;

__attribute__((section(".kernel_args"))) kernel_args_t kernel_args;

void __attribute__ ((noinline)) schedule_kernel(kernel_args_t *kernel_args)
{
  tasks_args.kernel_args = kernel_args;
  spawn_warps();
}

void __attribute__ ((noinline)) spawn_warps()
{
  unsigned int num_tasks                = (unsigned int) tasks_args.kernel_args->num_tasks;

  unsigned int compute_unit_id          = vx_core_id();
  unsigned int num_compute_units        = vx_num_cores();
  unsigned int warps_per_compute_unit   = vx_num_warps();
  unsigned int threads_per_warp         = vx_num_threads();

  unsigned int threads_per_compute_unit = warps_per_compute_unit * threads_per_warp;
  unsigned int threads_per_gpu          = threads_per_compute_unit * num_compute_units;

  unsigned int needed_threads           = num_tasks;
  unsigned int needed_warps             = needed_threads / threads_per_warp;
  unsigned int needed_compute_units     = needed_threads / threads_per_compute_unit;
  unsigned int needed_gpu_iterations    = needed_threads / threads_per_gpu;

  tasks_args.global_id[compute_unit_id] = 0;

  if (needed_gpu_iterations > 0)
  {
    tasks_args.active_threads[compute_unit_id] = threads_per_warp;
    tasks_args.active_warps[compute_unit_id]   = warps_per_compute_unit;

    for (int i = 0; i < needed_gpu_iterations; i++)
    {
      vx_wspawn(warps_per_compute_unit, spawn_threads);
      spawn_threads();
      tasks_args.global_id[compute_unit_id] = tasks_args.global_id[compute_unit_id] + threads_per_gpu;
    }

    needed_threads       = needed_threads - (needed_gpu_iterations * threads_per_gpu);
    needed_warps         = needed_threads / threads_per_warp;
    needed_compute_units = needed_threads / threads_per_compute_unit;
  }

  if (compute_unit_id < needed_compute_units)
  {
    tasks_args.active_threads[compute_unit_id] = threads_per_warp;
    tasks_args.active_warps[compute_unit_id]   = warps_per_compute_unit;

    vx_wspawn(warps_per_compute_unit, spawn_threads);
    spawn_threads();
    tasks_args.global_id[compute_unit_id] = tasks_args.global_id[compute_unit_id] + (needed_compute_units * threads_per_compute_unit);

    needed_threads = needed_threads - (needed_compute_units * threads_per_compute_unit);
    needed_warps   = needed_threads / threads_per_warp;
  }

  if (compute_unit_id == 0)
  {
    if (needed_warps > 0)
    {
      tasks_args.active_threads[0] = threads_per_warp;
      tasks_args.active_warps[0]   = needed_warps;

      vx_wspawn(needed_warps, spawn_threads);
      spawn_threads();
      tasks_args.global_id[0] = tasks_args.global_id[0] + (needed_warps * threads_per_warp);

      needed_threads = needed_threads - (needed_warps * threads_per_warp);
    }

    if (needed_threads > 0)
    {
      tasks_args.active_threads[0] = needed_threads;
      tasks_args.active_warps[0]   = 1;
      spawn_threads();
    }
  }
}

void __attribute__ ((noinline)) spawn_threads()
{
  unsigned int compute_unit_id = vx_core_id();
  unsigned int warp_id         = vx_warp_id();

  vx_tmc((1 << tasks_args.active_threads[compute_unit_id]) - 1);
  spawn_tasks();

  vx_tmc(0 == warp_id);
}

void __attribute__ ((noinline)) spawn_tasks()
{
  unsigned int thread_id              = vx_thread_id();
  unsigned int warp_id                = vx_warp_id();
  unsigned int compute_unit_id        = vx_core_id();
  unsigned int threads_per_warp       = vx_num_threads();
  unsigned int warps_per_compute_unit = vx_num_warps();

  unsigned int threads_per_compute_unit = warps_per_compute_unit * threads_per_warp;

  unsigned int task_id = tasks_args.global_id[compute_unit_id] + (compute_unit_id * threads_per_compute_unit) + (warp_id * threads_per_warp) + thread_id;

  kernel(task_id);

  vx_barrier(0, tasks_args.active_warps[compute_unit_id]);
}
