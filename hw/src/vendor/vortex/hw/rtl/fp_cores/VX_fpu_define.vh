`ifndef VX_FPU_DEFINE
`define VX_FPU_DEFINE

`include "VX_define.vh"

`define SEL_SYNTHESIS

`ifndef SEL_SYNTHESIS
`include "float_dpi.vh"
`endif

`IGNORE_WARNINGS_BEGIN
import fpu_types::*;
`IGNORE_WARNINGS_END

`endif
