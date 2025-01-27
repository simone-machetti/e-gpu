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
  volatile unsigned int local_id[NUM_COMPUTE_UNITS];
  volatile unsigned int active_warps[NUM_COMPUTE_UNITS];
  volatile unsigned int active_threads[NUM_COMPUTE_UNITS];
  volatile kernel_args_t *kernel_args;
} tasks_args_t;

__attribute__ ((noinline)) void spawn_warps(void);
__attribute__ ((noinline)) void spawn_threads(void);
__attribute__ ((noinline)) void spawn_tasks(void);

volatile tasks_args_t tasks_args;

__attribute__((section(".kernel_args"))) kernel_args_t kernel_args;

__attribute__ ((noinline)) void schedule_kernel(kernel_args_t *kernel_args)
{
  tasks_args.kernel_args = kernel_args;
  spawn_warps();
}

__attribute__ ((noinline)) void spawn_warps()
{
  unsigned int global_work_size                 = (unsigned int)tasks_args.kernel_args->global_work_size;
  unsigned int local_work_size                  = (unsigned int)tasks_args.kernel_args->local_work_size;

  unsigned int num_compute_units                = vx_num_cores();
  unsigned int compute_unit_id                  = vx_core_id();
  unsigned int num_threads_per_warp             = vx_num_threads();
  unsigned int num_warps_per_compute_unit       = vx_num_warps();

  unsigned int threads_per_compute_unit         = num_threads_per_warp * num_warps_per_compute_unit;
  unsigned int num_work_groups                  = global_work_size / local_work_size;
  unsigned int num_work_groups_per_compute_unit = num_work_groups / num_compute_units;
  unsigned int num_iterations_per_work_group    = local_work_size / threads_per_compute_unit;

  unsigned int remaining_threads;
  unsigned int remaining_warps;
  unsigned int remaining_work_groups;

  tasks_args.global_id[compute_unit_id] = compute_unit_id * local_work_size;

  remaining_work_groups = num_work_groups;

  if (num_work_groups_per_compute_unit > 0)
  {
    for (int i = 0; i < num_work_groups_per_compute_unit; i++)
    {
      remaining_threads = local_work_size;
      remaining_warps   = remaining_threads / num_threads_per_warp;

      if (num_iterations_per_work_group > 0)
      {
        tasks_args.active_threads[compute_unit_id] = num_threads_per_warp;
        tasks_args.active_warps[compute_unit_id]   = num_warps_per_compute_unit;

        for (int i = 0; i < num_iterations_per_work_group; i++)
        {
          vx_wspawn(num_warps_per_compute_unit, spawn_threads);
          spawn_threads();
          tasks_args.global_id[compute_unit_id] = tasks_args.global_id[compute_unit_id] + threads_per_compute_unit;
        }

        remaining_threads = remaining_threads - (threads_per_compute_unit * num_iterations_per_work_group);
        remaining_warps   = remaining_threads / num_threads_per_warp;
      }

      if (remaining_warps > 0)
      {
        tasks_args.active_threads[compute_unit_id] = num_threads_per_warp;
        tasks_args.active_warps[compute_unit_id]   = remaining_warps;

        vx_wspawn(remaining_warps, spawn_threads);
        spawn_threads();
        tasks_args.global_id[compute_unit_id] = tasks_args.global_id[compute_unit_id] + (remaining_warps * num_threads_per_warp);

        remaining_threads = remaining_threads - (remaining_warps * num_threads_per_warp);
      }

      if (remaining_threads > 0)
      {
        tasks_args.active_threads[compute_unit_id] = remaining_threads;
        tasks_args.active_warps[compute_unit_id]   = 1;
        spawn_threads();
        tasks_args.global_id[compute_unit_id] = tasks_args.global_id[compute_unit_id] + remaining_threads;
      }

      tasks_args.global_id[compute_unit_id] = tasks_args.global_id[compute_unit_id] + (local_work_size * (num_compute_units - 1));
    }

    remaining_work_groups = remaining_work_groups - (num_work_groups_per_compute_unit * num_compute_units);
  }

  if (remaining_work_groups > 0)
  {
    if (compute_unit_id < remaining_work_groups)
    {
      remaining_threads = local_work_size;
      remaining_warps   = remaining_threads / num_threads_per_warp;

      if (num_iterations_per_work_group > 0)
      {
        tasks_args.active_threads[compute_unit_id] = num_threads_per_warp;
        tasks_args.active_warps[compute_unit_id]   = num_warps_per_compute_unit;

        for (int i = 0; i < num_iterations_per_work_group; i++)
        {
          vx_wspawn(num_warps_per_compute_unit, spawn_threads);
          spawn_threads();
          tasks_args.global_id[compute_unit_id] = tasks_args.global_id[compute_unit_id] + threads_per_compute_unit;
        }

        remaining_threads = remaining_threads - (threads_per_compute_unit * num_iterations_per_work_group);
        remaining_warps   = remaining_threads / num_threads_per_warp;
      }

      if (remaining_warps > 0)
      {
        tasks_args.active_threads[compute_unit_id] = num_threads_per_warp;
        tasks_args.active_warps[compute_unit_id]   = remaining_warps;

        vx_wspawn(remaining_warps, spawn_threads);
        spawn_threads();
        tasks_args.global_id[compute_unit_id] = tasks_args.global_id[compute_unit_id] + (remaining_warps * num_threads_per_warp);

        remaining_threads = remaining_threads - (remaining_warps * num_threads_per_warp);
      }

      if (remaining_threads > 0)
      {
        tasks_args.active_threads[compute_unit_id] = remaining_threads;
        tasks_args.active_warps[compute_unit_id]   = 1;
        spawn_threads();
        tasks_args.global_id[compute_unit_id] = tasks_args.global_id[compute_unit_id] + remaining_threads;
      }
    }
  }
}

__attribute__ ((noinline)) void spawn_threads()
{
  unsigned int compute_unit_id = vx_core_id();
  unsigned int warp_id         = vx_warp_id();

  vx_tmc((0xFFFFFFFF >> (32 - tasks_args.active_threads[compute_unit_id])));
  spawn_tasks();

  vx_tmc(0 == warp_id);
}

__attribute__ ((noinline)) void spawn_tasks()
{
  unsigned int thread_id            = vx_thread_id();
  unsigned int warp_id              = vx_warp_id();
  unsigned int compute_unit_id      = vx_core_id();
  unsigned int num_threads_per_warp = vx_num_threads();

  unsigned int task_id = tasks_args.global_id[compute_unit_id] + (warp_id * num_threads_per_warp) + thread_id;

  kernel(task_id);

  vx_barrier(0, tasks_args.active_warps[compute_unit_id]);
}
