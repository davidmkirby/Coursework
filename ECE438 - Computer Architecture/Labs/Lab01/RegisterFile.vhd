---------------------------------------------------
-- This source file describes a 32x32 register file such
-- that the 0th register is always 0 and is not writeable
---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

---------------------------------------------------

entity RegisterFile is

  port (
    RdRegA : in std_logic_vector(4 downto 0);
    RdRegB : in std_logic_vector(4 downto 0);
    WrReg : in std_logic_vector(4 downto 0);
    Clk : in std_logic;
    RegWrEn : in std_logic;
    WrData : in std_logic_vector(31 downto 0);
    RdDataA : out std_logic_vector(31 downto 0);
    RdDataB : out std_logic_vector(31 downto 0)
  );
end RegisterFile;

---------------------------------------------------

architecture RegisterFile of RegisterFile is

  ---------------------------------------------------
  --create an array of 31 32-bit registers
  type register_array is array (1 to 31) of
  std_logic_vector (31 downto 0);
  signal Registers : register_array;
  ---------------------------------------------------

begin

  ---------------------------------------------------
  --describe the write functionality
  process (Clk) --only do something if clock changes
  begin
    --on the falling edge of clock
    if (Clk'event and Clk = '0') then
      --only write if enabled and not
      --attempting to write to 0 reg
      if (RegWrEn = '1' and conv_integer(WrReg) /= 0) then
        Registers(conv_integer(WrReg)) <= WrData;
      end if;
    end if;
  end process;
  ---------------------------------------------------
  --describe the read functionality
  process (RdRegA, Registers) begin
    if (conv_integer(RdRegA) = 0) then
      RdDataA <=
        (others => '0'); --implements our $zero register
    else
      RdDataA <= Registers(conv_integer(RdRegA));
    end if;
  end process;

  process (RdRegB, Registers) begin
    if (conv_integer(RdRegB) = 0) then
      RdDataB <=
        (others => '0'); --implements our $zero register
    else
      RdDataB <= Registers(conv_integer(RdRegB));
    end if;
  end process;
end RegisterFile;