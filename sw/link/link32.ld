/* Copyright 2023 EPFL
*  Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
*  SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
*
*  Author: Simone Machetti - simone.machetti@epfl.ch */

OUTPUT_FORMAT("elf32-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
  KERNEL_CODE  (RWX) : ORIGIN = 0x00000000 , LENGTH = 0x10000
  KERNEL_STACK (RWX) : ORIGIN = 0x00010000 , LENGTH = 0x10000
  KERNEL_ARGS  (RWX) : ORIGIN = 0x00020000 , LENGTH = 0x10000
  KERNEL_DATA  (RWX) : ORIGIN = 0x00030000 , LENGTH = 0x10000
  KERNEL_LOCAL (RWX) : ORIGIN = 0x00040000 , LENGTH = 0x10000
}

__stack_size = 0x10000;

SECTIONS
{
  .start MAX(0x00000000, ALIGN(64)) :
  {
    . = ALIGN(64);
    *(.start*)
    . = ALIGN(64);
  } > KERNEL_CODE

  .text :
  {
    . = ALIGN(64);
    *(.text*)
    . = ALIGN(64);
  } > KERNEL_CODE

  .data :
  {
    . = ALIGN(64);
    *(.data*)
    . = ALIGN(64);
  } > KERNEL_CODE

  .rodata :
  {
    . = ALIGN(64);
    *(.rodata*)
    . = ALIGN(64);
  } > KERNEL_CODE

  .bss :
  {
    . = ALIGN(64);
    *(.bss*)
    . = ALIGN(64);
  } > KERNEL_CODE

  .stack :
  {
    . = ALIGN(64);
    . = . + __stack_size;
    __stack = .;
    . = ALIGN(64);
  } > KERNEL_STACK

  .kernel_args : {
    . = ALIGN(64);
    *(.kernel_args)
    . = ALIGN(64);
  } > KERNEL_ARGS

  .kernel_data : {
    . = ALIGN(64);
    *(.kernel_data)
    . = ALIGN(64);
  } > KERNEL_DATA

  .kernel_local : {
    . = ALIGN(64);
    *(.kernel_local)
    . = ALIGN(64);
  } > KERNEL_LOCAL

  /DISCARD/ : {
    *(*)
  }
}
