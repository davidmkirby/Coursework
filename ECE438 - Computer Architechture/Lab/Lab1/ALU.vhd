---------------------------------------------------
-- Put some comments here describing the ALU
---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; --needed to describe
use ieee.std_logic_arith.all; --arithmetic on std_logic_vector
use ieee.numeric_std.all; --types. Treated as unsigned!
entity ALU is

port( AluCtrl: in std_logic_vector(3 downto 0);
      AluInA, AluInB: in std_logic_vector(31 downto 0);
      AluResult: out std_logic_vector(31 downto 0)--;
--      Equals: out std_logic
);
end ALU;

architecture ALU of ALU is

begin

  process(AluInA, AluInB, AluCtrl)
  begin
    case AluCtrl is
              when b"0000" => --AND
                  AluResult <= AluInA and AluInB;
              when b"0001" => --OR
                  AluResult <= AluInA or AluInB;
              when b"0011" => --SLL
                  AluResult <= to_stdlogicvector(to_bitvector(AluInB) sll conv_integer(AluInA));
              when b"0100" => --SRL
                  AluResult <= to_stdlogicvector(to_bitvector(AluInB) srl conv_integer(AluInA));
              when b"1000" => --ADDU
                  AluResult <= AluInA + AluInB;
              when b"1001" => --SUBU
                  AluResult <= AluInA - AluInB;
              when b"1010" => --XOR
                  AluResult <= AluInA xor AluInB;
              when b"1011" => --SLTU
                  if (AluInA) < (AluInB) then
                      AluResult <= (0 => '1', others => '0');
                  else
                      AluResult <= (others => '0');
                  end if;
              when b"1100" => --NOR
                  AluResult <= AluInA nor AluInB;
              when b"1101" => --SRA
                  AluResult <= to_stdlogicvector(to_bitvector(AluInB) sra conv_integer(AluInA));
              when b"1110" => --LUI
                  AluResult <= AluInA(31 downto 16) & AluInB(15 downto 0);
              when b"0010" => --others
                  NULL;
              when b"0111" => --others
                  NULL;
              when b"0101" => --others
                  NULL;
              when b"1111" => --others
                  NULL;
              when others => -- others
                  NULL;
      end case;
  end process;
end ALU;
