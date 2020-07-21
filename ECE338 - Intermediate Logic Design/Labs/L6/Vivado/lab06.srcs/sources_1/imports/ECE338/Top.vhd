library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Top is
   port (
      BRAM_PORTA_addr : out STD_LOGIC_VECTOR (12 downto 0);
      BRAM_PORTA_dout : out STD_LOGIC_VECTOR (15 downto 0);
      BRAM_PORTA_din : in STD_LOGIC_VECTOR (15 downto 0);
      BRAM_PORTA_we : out STD_LOGIC_VECTOR (0 to 0);
      FCLK_CLK0 : in STD_LOGIC;
      FCLK_RESET0_N : in STD_LOGIC;
      gpio_ins : in STD_LOGIC_VECTOR (31 downto 0);
      gpio_outs : out STD_LOGIC_VECTOR (31 downto 0)
   );
end Top;

architecture rtl of Top is
begin

   BRAM_PORTA_addr <= (others => '0');
   BRAM_PORTA_dout <= (others => '0');
   BRAM_PORTA_we <= (others => '0');
   gpio_outs <= gpio_ins;
end rtl;