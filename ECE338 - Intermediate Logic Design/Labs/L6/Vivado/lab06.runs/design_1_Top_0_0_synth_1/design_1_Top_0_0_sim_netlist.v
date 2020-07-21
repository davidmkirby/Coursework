// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
// Date        : Thu Oct  3 19:49:55 2019
// Host        : ubuntu running 64-bit Ubuntu 18.04.3 LTS
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_Top_0_0_sim_netlist.v
// Design      : design_1_Top_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_Top_0_0,Top,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* ip_definition_source = "module_ref" *) 
(* x_core_info = "Top,Vivado 2018.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (BRAM_PORTA_addr,
    BRAM_PORTA_dout,
    BRAM_PORTA_din,
    BRAM_PORTA_we,
    FCLK_CLK0,
    FCLK_RESET0_N,
    gpio_ins,
    gpio_outs);
  output [12:0]BRAM_PORTA_addr;
  output [15:0]BRAM_PORTA_dout;
  input [15:0]BRAM_PORTA_din;
  output [0:0]BRAM_PORTA_we;
  input FCLK_CLK0;
  input FCLK_RESET0_N;
  input [31:0]gpio_ins;
  output [31:0]gpio_outs;

  wire \<const0> ;
  wire [31:0]gpio_ins;

  assign BRAM_PORTA_addr[12] = \<const0> ;
  assign BRAM_PORTA_addr[11] = \<const0> ;
  assign BRAM_PORTA_addr[10] = \<const0> ;
  assign BRAM_PORTA_addr[9] = \<const0> ;
  assign BRAM_PORTA_addr[8] = \<const0> ;
  assign BRAM_PORTA_addr[7] = \<const0> ;
  assign BRAM_PORTA_addr[6] = \<const0> ;
  assign BRAM_PORTA_addr[5] = \<const0> ;
  assign BRAM_PORTA_addr[4] = \<const0> ;
  assign BRAM_PORTA_addr[3] = \<const0> ;
  assign BRAM_PORTA_addr[2] = \<const0> ;
  assign BRAM_PORTA_addr[1] = \<const0> ;
  assign BRAM_PORTA_addr[0] = \<const0> ;
  assign BRAM_PORTA_dout[15] = \<const0> ;
  assign BRAM_PORTA_dout[14] = \<const0> ;
  assign BRAM_PORTA_dout[13] = \<const0> ;
  assign BRAM_PORTA_dout[12] = \<const0> ;
  assign BRAM_PORTA_dout[11] = \<const0> ;
  assign BRAM_PORTA_dout[10] = \<const0> ;
  assign BRAM_PORTA_dout[9] = \<const0> ;
  assign BRAM_PORTA_dout[8] = \<const0> ;
  assign BRAM_PORTA_dout[7] = \<const0> ;
  assign BRAM_PORTA_dout[6] = \<const0> ;
  assign BRAM_PORTA_dout[5] = \<const0> ;
  assign BRAM_PORTA_dout[4] = \<const0> ;
  assign BRAM_PORTA_dout[3] = \<const0> ;
  assign BRAM_PORTA_dout[2] = \<const0> ;
  assign BRAM_PORTA_dout[1] = \<const0> ;
  assign BRAM_PORTA_dout[0] = \<const0> ;
  assign BRAM_PORTA_we[0] = \<const0> ;
  assign gpio_outs[31:0] = gpio_ins;
  GND GND
       (.G(\<const0> ));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
