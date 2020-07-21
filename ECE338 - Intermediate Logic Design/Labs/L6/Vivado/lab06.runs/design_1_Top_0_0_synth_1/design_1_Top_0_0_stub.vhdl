-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
-- Date        : Thu Oct  3 19:49:54 2019
-- Host        : ubuntu running 64-bit Ubuntu 18.04.3 LTS
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_Top_0_0_stub.vhdl
-- Design      : design_1_Top_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    BRAM_PORTA_addr : out STD_LOGIC_VECTOR ( 12 downto 0 );
    BRAM_PORTA_dout : out STD_LOGIC_VECTOR ( 15 downto 0 );
    BRAM_PORTA_din : in STD_LOGIC_VECTOR ( 15 downto 0 );
    BRAM_PORTA_we : out STD_LOGIC_VECTOR ( 0 to 0 );
    FCLK_CLK0 : in STD_LOGIC;
    FCLK_RESET0_N : in STD_LOGIC;
    gpio_ins : in STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio_outs : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "BRAM_PORTA_addr[12:0],BRAM_PORTA_dout[15:0],BRAM_PORTA_din[15:0],BRAM_PORTA_we[0:0],FCLK_CLK0,FCLK_RESET0_N,gpio_ins[31:0],gpio_outs[31:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "Top,Vivado 2018.2";
begin
end;
