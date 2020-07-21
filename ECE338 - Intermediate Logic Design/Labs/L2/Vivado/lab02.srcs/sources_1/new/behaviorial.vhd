library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Index is
	port (
		ctrl : in std_logic_vector(1 downto 0);
		a : out std_logic_vector(3 downto 0)
	);
end Index;

architecture rtl of Index is
	signal au : unsigned(3 downto 0);
begin
	process (au, ctrl)
	begin
		au <= (others => '0');
		au(to_integer(unsigned(ctrl))) <= '1';
		a <= std_logic_vector(au);
	end process;
end rtl;