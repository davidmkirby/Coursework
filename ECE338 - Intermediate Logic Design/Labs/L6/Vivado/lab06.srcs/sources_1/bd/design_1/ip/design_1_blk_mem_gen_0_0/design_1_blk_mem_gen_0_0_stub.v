// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
// Date        : Thu Oct  3 19:40:42 2019
// Host        : ubuntu running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub {/media/psf/Home/OneDrive/OneDrive - University of New
//               Mexico/FALL2019/ECE338/lab06/lab06.srcs/sources_1/bd/design_1/ip/design_1_blk_mem_gen_0_0/design_1_blk_mem_gen_0_0_stub.v}
// Design      : design_1_blk_mem_gen_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2018.2" *)
module design_1_blk_mem_gen_0_0(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[12:0],dina[15:0],douta[15:0]" */;
  input clka;
  input [0:0]wea;
  input [12:0]addra;
  input [15:0]dina;
  output [15:0]douta;
endmodule
