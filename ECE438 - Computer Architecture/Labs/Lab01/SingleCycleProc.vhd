--------------------------------------------------------------------------------
-- This VHDL source file describes the basic single-cycle processor
-- discussed in David Patterson and John Hennessy’s Computer Organization and
-- Design textbook.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- needed to describe
use ieee.std_logic_arith.all; -- arithmetic
--------------------------------------------------------------------------------

entity SingleCycleProc is

    port (
        Clk, Rst_L : in std_logic;
        PC : out std_logic_vector(31 downto 0);
        Instruction : in std_logic_vector(31 downto 0);
        DataMemAddr : out std_logic_vector(31 downto 0);
        DataMemRdEn, DataMemWrEn : out std_logic;
        DataMemRdData : in std_logic_vector(31 downto 0);
        DataMemWrData : out std_logic_vector(31 downto 0)
    );
end SingleCycleProc;
--------------------------------------------------------------------------------

architecture SingleCycleProc of SingleCycleProc is

    -- Component declarations go here...

    component RegisterFile is
        port (
            RdRegA : in std_logic_vector(4 downto 0);
            --insert code here for read port B
            WrReg : in std_logic_vector(4 downto 0);
            Clk : in std_logic;
            --something else is missing here...
            WrData : in std_logic_vector(31 downto 0);
            RdDataA : out std_logic_vector(31 downto 0);
            --insert code here for read port B
        );
    end component;

    -- Declare signals and variables here
    -- Typically, the code is easier to read if signals are
    -- declared in the order they appear below...
    signal Rs, Rt, Rd : std_logic_vector(4 downto 0);
    signal AluInA : std_logic_vector(31 downto 0);
    signal AluInB : std_logic_vector(31 downto 0);
    signal AluResult : std_logic_vector(31 downto 0);
    signal Equals : std_logic;
    signal RegDst : std_logic;
    signal WrReg : std_logic_vector(4 downto 0);
    signal RegWrData : std_logic_vector(31 downto 0);
    --fill in the rest here

    --------------------------------------------------------------------------------
begin
    --describe PC logic here

    --break up instruction into parts for readability
    Rs <= Instruction(25 downto 21);
    Rt <= Instruction(20 downto 16);

    --instantiate the register file
    --instance_name: component_name
    -- use nominal port map as opposed to positional!
    Registers : RegisterFile
    port map(
        RdRegA => Rs,
        RdRegB => Rt,
        WrReg => WrReg,
        Clk => Clk,
        WrData => RegWrData,
        --okay you get the point...
    );

    --zero extend the shift amount field
    Shamt(4 downto 0) <= Instruction(10 downto 6);
    Shamt(31 downto 5) <= (others => ’0’);

    -- ALU source mux for OpA
    -- The WITH/SELECT/WHEN construct is great for muxes
    with UseShamt select
        -- the zero extended shamt field
        AluInA <= Shamt when ’1’,
        -- the register file output
        RdRegA when others; --avoids latches!

    -- ALU should be instantiated somewhere here...

    --Describe register destination mux using when/else
    WrReg <= Rd when (RegDst = ’1’) else --finish this line

    end SingleCycleProc;
    --------------------------------------------------------------------------------