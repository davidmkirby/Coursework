---------------------------------------------------
-- This component describes the ALU decode unit
-- in our MIPS processor.
---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------

entity AluDecode is

    port (
        AluOp : in std_logic_vector(3 downto 0);
        Funct : in std_logic_vector(5 downto 0);
        AluCtrl : out std_logic_vector(3 downto 0)
    );
end AluDecode;

---------------------------------------------------

architecture AluDecode of AluDecode is

begin
    process (AluOp, Funct) -- output depends on AluOp field and Funct
    begin
        if AluOp = b"1111" then
            case Funct is
                when b"000000" =>
                when others => AluCtrl

            end case;
        end if;

    end process;
end AluDecode;