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
  INSTR_RAM (RWX) : ORIGIN = 0x00000000 , LENGTH = 0x08000
  DATA_RAM  (RWX) : ORIGIN = 0X00008000 , LENGTH = 0X1FC00
  ARGS_RAM  (RWX) : ORIGIN = 0x00027C00 , LENGTH = 0x00400
}

__stack_size = 0x8000;

SECTIONS
{
  .start MAX(0x00000000, ALIGN(4)) :
  {
    . = ALIGN(4);
    *(.start*)
    . = ALIGN(4);
  } > INSTR_RAM

  .text :
  {
    . = ALIGN(4);
    *(.text*)
    . = ALIGN(4);
  } > INSTR_RAM

  .data :
  {
    . = ALIGN(4);
    *(.data*)
    . = ALIGN(4);
  } > DATA_RAM

  .rodata :
  {
    . = ALIGN(4);
    *(.rodata*)
    . = ALIGN(4);
  } > DATA_RAM

  .bss :
  {
    . = ALIGN(4);
    *(.bss*)
    . = ALIGN(4);
  } > DATA_RAM

  .stack :
  {
    . = ALIGN(4);
    __stack_start = .;
    . = . + __stack_size;
    __stack = .;
    . = ALIGN(4);
  } > DATA_RAM

  .args : {
    . = ALIGN(4);
    *(.args)
    . = ALIGN(4);
  } > ARGS_RAM

  /DISCARD/ : {
    *(*)
  }
}
