library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
entity PriorityMUX is
	port (
		inputs : in std_logic_vector(3 downto 0);
		ctrl : in std_logic_vector(3 downto 0);
		leds : out std_logic_vector(1 downto 0)
	);
end PriorityMUX;
architecture rtl of PriorityMUX is
begin
	-- Priority MUX via conditional signal assignment
	leds(0) <= inputs(0) when ctrl(0) = '1' else
	inputs(1) when ctrl(1) = '1' else
	'0';
	process (inputs, ctrl)
	begin
		leds(1) <= '0';
		-- Priority MUX via if assignment
		if (ctrl(2) = '1') then
			leds(1) <= inputs(2);
		elsif (ctrl(3) = '1') then
			leds(1) <= inputs(3);
		end if;
	end process;
end rtl;