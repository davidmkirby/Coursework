// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
// Date        : Thu Oct  3 19:49:56 2019
// Host        : ubuntu running 64-bit Ubuntu 18.04.3 LTS
// Command     : write_verilog -force -mode synth_stub {/media/psf/Home/OneDrive/OneDrive - University of New
//               Mexico/FALL2019/ECE338/lab06/lab06.srcs/sources_1/bd/design_1/ip/design_1_Top_0_0/design_1_Top_0_0_stub.v}
// Design      : design_1_Top_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "Top,Vivado 2018.2" *)
module design_1_Top_0_0(BRAM_PORTA_addr, BRAM_PORTA_dout, 
  BRAM_PORTA_din, BRAM_PORTA_we, FCLK_CLK0, FCLK_RESET0_N, gpio_ins, gpio_outs)
/* synthesis syn_black_box black_box_pad_pin="BRAM_PORTA_addr[12:0],BRAM_PORTA_dout[15:0],BRAM_PORTA_din[15:0],BRAM_PORTA_we[0:0],FCLK_CLK0,FCLK_RESET0_N,gpio_ins[31:0],gpio_outs[31:0]" */;
  output [12:0]BRAM_PORTA_addr;
  output [15:0]BRAM_PORTA_dout;
  input [15:0]BRAM_PORTA_din;
  output [0:0]BRAM_PORTA_we;
  input FCLK_CLK0;
  input FCLK_RESET0_N;
  input [31:0]gpio_ins;
  output [31:0]gpio_outs;
endmodule
