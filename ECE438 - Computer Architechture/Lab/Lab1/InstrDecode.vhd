---------------------------------------------------
-- This component describes the instruction decode unit
-- in our MIPS processor.
---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------

entity InstrDecode is

port(
        --6-bit op field of instruction
        Opcode: in std_logic_vector(5 downto 0);
        --6-bit funct field of instruction
        Funct: in std_logic_vector(5 downto 0);
        -- asserted when shamt field is input to ALU
        UseShamt: out std_logic;
        -- asserted when the immediate field is input to ALU
        UseImmed: out std_logic;
        -- asserted when immed needs to be sign extended
        SignExtend: out std_logic;
        -- asserted when instruction is a jump
        Jump: out std_logic;
        -- asserted when instruction is a branch
        Branch: out std_logic;
        -- Determines ALU operation, see ALU decode unit
        AluOp: out std_logic_vector(3 downto 0);
        -- selects between rt and rd for the register destination
        RegDst: out std_logic;
        -- asserted when reading from memory (loads!)
        MemRdEn: out std_logic;
        -- asserted when writing to memory (stores!)
        MemWrEn: out std_logic;
        -- selects the source for writing into register file
        RegSrc: out std_logic;
        -- asserted when writing into register file
        RegWrEn: out std_logic
        -- that's all folks!
);
end InstrDecode;

---------------------------------------------------

architecture InstrDecode of InstrDecode is

begin
        --One big ol' case statement makes this description easy!
    process(Opcode, Funct) -- output depends on op field and funct
        begin
        case Opcode is
                -- R-type instruction
                        -- For our small instruction set, the R-type instruction
                        -- is the only instruction where we have to look at the
                        -- function field...
                when b"000000" =>   -- SLL, SRL, and SRA use the shamt field
                        if(Funct=b"000000"
                        or Funct=b"000010"
                        or Funct=b"000011") then
                                UseShamt <= '1';  -- using shamt
                        else
                                UseShamt <= '0';  -- not using shamt
                        end if;
                    UseImmed    <= '0';   -- not immediate
                    SignExtend  <= '-';   -- doesn't matter
                    Jump        <= '0';   -- don't jump!
                    Branch      <= '0';   -- don't branch either
                    AluOp   <= b"1111";   -- use function field
                    RegDst      <= '1';   -- rd specifies destination
                    MemRdEn     <= '0';   -- leave memory alone
                    MemWrEn     <= '0';
                    RegSrc      <= '1';   -- use ALU ouput
                    RegWrEn     <= '1';   -- writing into register file

                when b"001001" =>        -- ADDIU
                    UseImmed    <= '1';  -- yes immediate
                    SignExtend  <= '1';  -- addiu is sign-extended
                    Jump        <= '0';  -- don't jump!
                    Branch      <= '0';  -- don't branch either
                    AluOp   <= b"1000";  -- use function field (from ALU.vhd)
                    RegDst      <= '0';  -- rt specifies destination
                    MemRdEn     <= '0';  -- leave memory alone
                    MemWrEn     <= '0';  --
                    RegSrc      <= '1';  -- use ALU ouput
                    RegWrEn     <= '1';  -- writing into register file
                    UseShamt    <= '0';  -- no shift amount


                        -- Fill in the rest of the supported instructions
                        -- to avoid describing latches
                when others =>
                        -- don't care because invalid instruction!
                        UseShamt <= '-';
                        UseImmed <= '-';
                        SignExtend <= '-';
                        Jump <= '0'; --don't jump!
                        Branch <= '0'; -- don't branch either
                        AluOp <= (others => '-');
                        -- fill in the rest here!
                        MemRdEn <= '0'; --leave memory alone
                        MemWrEn <= '0';
                        -- finish this, but don't allow state to change
                -- when an invalid instruction is encountered!
                -- I'm going to test for this, so get it right...
        end case;
    end process;
    -- was that so hard?!?
end InstrDecode;
