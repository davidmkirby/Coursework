---------------------------------------------------
-- Arithmetic Logic Unit (ALU) takes at most two
-- 32-bit inputs and outputs one 32-bit result.
-- This is done via purely combinational logic.
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
--      Equals: out std_logic       -- not needed yet
);
end ALU;

architecture ALU of ALU is

begin

  process(AluInA, AluInB, AluCtrl)
  begin
    case AluCtrl is
              -- Bitwise ands two registers and stores the result in a register
          when b"0000" => --AND
              AluResult <= AluInA and AluInB;

              -- Bitwise logical ors two registers and stores the result in a
              -- register
          when b"0001" => --OR
              AluResult <= AluInA or AluInB;

              -- Shifts a register value left by the shift amount listed in the
              -- instruction and places the result in a third register. Zeroes
              -- are shifted in.
          when b"0011" => --SLL
              AluResult <= to_stdlogicvector(to_bitvector(AluInB) sll conv_integer(AluInA));

              -- Shifts a register value right by the shift amount (shamt) and
              -- places the value in the destination register. Zeroes are
              -- shifted in.
          when b"0100" => --SRL
              AluResult <= to_stdlogicvector(to_bitvector(AluInB) srl conv_integer(AluInA));

              -- Adds two registers and stores the result in a register
          when b"1000" => --ADDU
              AluResult <= AluInA + AluInB;

              -- Subtracts two registers and stores the result in a register
          when b"1001" => --SUBU
              AluResult <= AluInA - AluInB;

              -- Exclusive ors two registers and stores the result in a register
          when b"1010" => --XOR
              AluResult <= AluInA xor AluInB;

              -- If $s is less than $t, $d is set to one. It gets zero
              -- otherwise.
          when b"1011" => --SLTU
              if (AluInA) < (AluInB) then
                  AluResult <= (0 => '1', others => '0');
              else
                  AluResult <= (others => '0');
              end if;

              -- Nors two registers and stores the result in a register
          when b"1100" => --NOR
              AluResult <= AluInA nor AluInB;

              -- Shifts a register value right by the shift amount (shamt) and
              -- places the value in the destination register. The sign bit is
              -- shifted in.
          when b"1101" => --SRA
              AluResult <= to_stdlogicvector(to_bitvector(AluInB) sra conv_integer(AluInA));

              -- The immediate value is shifted left 16 bits and stored in the
              -- register. The lower 16 bits are zeroes.
          when b"1110" => --LUI
              AluResult <= AluInB(15 downto 0) & x"0000";

              -- Everything else
          when others => -- others
              AluResult <= (others => '-');
      end case;
  end process;
end ALU;
