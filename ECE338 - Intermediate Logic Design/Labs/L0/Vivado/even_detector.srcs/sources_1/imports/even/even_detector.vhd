library ieee;
use ieee.std_logic_1164.all;

entity even_detector is
   port (
      a : in std_logic_vector(2 downto 0);
      even : out std_logic
   );
end even_detector;

architecture sop_arch of even_detector is
   signal p1, p2, p3, p4 : std_logic;
begin
   even <= (p1 or p2) or (p3 or p4);
   p1 <= (not a(2)) and (not a(1)) and (not a(0));
   p2 <= (not a(2)) and a(1) and a(0);
   p3 <= a(2) and (not a(1)) and a(0);
   p4 <= a(2) and a(1) and (not a(0));
end sop_arch;