library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity FA_ED is
   port (
      a : in STD_LOGIC;
      b : in STD_LOGIC;
      c : in STD_LOGIC;
      ctrl : in STD_LOGIC;
      Cout : out STD_LOGIC;
      sum : out STD_LOGIC
   );
end FA_ED;

architecture rtl of FA_ED is
begin

   process (a, b, c)
   begin
      Cout <= '0';
      sum <= '0';

      if (ctrl = '0') then
         Cout <= ((a and b) or (a and c) or (b and c)) and (not a and not b and not c);
         sum <= '0';
      else
         Cout <= (a and b) or (a and c) or (b and c);
         sum <= a xor b xor c;
      end if;
   end process;
end rtl;