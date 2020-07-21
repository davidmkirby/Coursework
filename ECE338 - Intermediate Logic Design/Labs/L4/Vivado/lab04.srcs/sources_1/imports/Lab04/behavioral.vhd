library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
entity Counter is
	port (
		clk : in std_logic;
		reset : in std_logic;
		ctrl : in std_logic_vector(3 downto 0);
		leds : out std_logic_vector(1 downto 0)
	);
end Counter;
architecture rtl of Counter is
	signal cnter1_reg, cnter1_next : unsigned(29 downto 0);
	signal cnter2_reg, cnter2_next : unsigned(29 downto 0);
begin
	process (clk, reset)
	begin
		if (reset = '1') then
			cnter1_reg <= (others => '0');
			cnter2_reg <= (others => '0');
		elsif (rising_edge(clk)) then
			cnter1_reg <= cnter1_next;
			cnter2_reg <= cnter2_next;
		end if;
	end process;
	-- Counter via conditional signal assignment
	cnter1_next <= cnter1_reg + 1 when ctrl(0) = '1' else
		cnter1_reg;
	leds(0) <= cnter1_reg(29) when ctrl(1) = '1' else
	'0';
	process (ctrl, cnter2_reg)
	begin
		leds(1) <= '0';
		cnter2_next <= cnter2_reg;
		-- Counter via if assignment
		if (ctrl(2) = '1') then
			cnter2_next <= cnter2_reg + 1;
		end if;
		if (ctrl(3) = '1') then
			leds(1) <= cnter2_reg(29);
		end if;
	end process;
end rtl;