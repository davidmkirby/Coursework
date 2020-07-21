--------------------------------------------------------------------------------
-- This VHDL source file describes the basic 5-stage pipelined processor
-- discussed in David Patterson and John Hennessy’s Computer Organization and
-- Design textbook. Instruction processing goes through the following stages:
--IF --- Instruction fetch: Here instructions are fetch, one per clock cycle,
-- from the memory pointed to by the Program Counter (PC).
--ID --- Instruction decode: The instruction fetched in the prevous stage is
-- decoded into a number of control signals that flow down the pipe.
-- Also, the register file is read in this stage. Data and control
-- dependencies are detected and handled in this stage, either with
-- forwarding or interlocking.
--EX --- Execute: The Arithmetic-Logic Unit (ALU) is in this stage. Also,
-- branches are resolved in the execute stage.
--MEM --- Memory: In this stage, memory is accessed. For a load, memory is
-- read, while for a store, memory is written.
--WB --- Write Back: This is the final stage of the pipeline. Here the
-- register file is written.
--
--The logic described in this src file attempts to follow the natural flow of
--the pipeline. PC logic and other instruction fetch related HW is described
--at the beginning, while Write-back logic is at the end.
--
--The signals in the pipeline attempt to adhere to the following format:
--prefix_signal_name_suffix
--A prefix identifies the location within the pipeline where a given signal
--comes from. If two stages are specified for the prefix, then the signal
--comes from the pipeline register between those two stages. For example,
--ID_EX_load is the load signal from the ID/EX pipeline register. If only one
--stage is specified in the prefix, the signal originates from the given
--stage. For example, ID_load originates from the decode unit within the ID
--stage. If no prefix exists, that signal is assumed to be contained within
--only one pipeline stage.
--A suffix indicates the destination of a signal and is added to a signal name
--only when necessary. Most signals are used in multiple stages and therefore
--have no specific destination. However, some signals have the same signal
--name but are expected to used in different stages. For example,
--DataMemForwardCtrl_EX and DataMemForwardCtrl_MEM are different signals,
--serving similar functions but destine for different stages.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; --needed to describe
use ieee.std_logic_arith.all; --arithmetic
--------------------------------------------------------------------------------

entity MIPSpipeline is

    port (
        Clk, Rst_L : in std_logic;
        PC : out std_logic_vector(31 downto 0);
        Instruction : in std_logic_vector(31 downto 0);
        DataMemAddr : out std_logic_vector(31 downto 0);
        DataMemRdEn, DataMemWrEn : out std_logic;
        DataMemRdData : in std_logic_vector(31 downto 0);
        DataMemWrData : out std_logic_vector(31 downto 0)
    );
end MIPSpipeline;

--------------------------------------------------------------------------------

architecture MIPSpipeline of MIPSpipeline is

    -- Component declarations go here...

    component RegisterFile is
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
    end component;

    component ALU is
        port (
            AluCtrl : in std_logic_vector(3 downto 0);
            AluInA, AluInB : in std_logic_vector(31 downto 0);
            AluResult : out std_logic_vector(31 downto 0)--;
            Equals : out std_logic
        );
    end component;

    component AluDecode is

        port (
            AluOp : in std_logic_vector(3 downto 0);
            Funct : in std_logic_vector(5 downto 0);
            AluCtrl : out std_logic_vector(3 downto 0)
        );
    end component;

    component InstrDecode is

        port (
            --6-bit op field of instruction
            Opcode : in std_logic_vector(5 downto 0);
            --6-bit funct field of instruction
            Funct : in std_logic_vector(5 downto 0);
            -- asserted when shamt field is input to ALU
            UseShamt : out std_logic;
            -- asserted when the immediate field is input to ALU
            UseImmed : out std_logic;
            -- asserted when immed needs to be sign extended
            SignExtend : out std_logic;
            -- asserted when instruction is a jump
            Jump : out std_logic;
            -- asserted when instruction is a branch
            Branch : out std_logic;
            -- Determines ALU operation, see ALU decode unit
            AluOp : out std_logic_vector(3 downto 0);
            -- selects between rt and rd for the register destination
            -- rt = 0, rd = 1
            RegDst : out std_logic;
            -- asserted when reading from memory (loads!)
            MemRdEn : out std_logic;
            -- asserted when writing to memory (stores!)
            MemWrEn : out std_logic;
            -- selects the source for writing into register file
            RegSrc : out std_logic;
            -- asserted when writing into register file
            RegWrEn : out std_logic
            -- that's all folks!
        );
    end component;

    component ForwardingUnit is

        port (
            UseShamt, UseImmed : in std_logic;
            EX_RegWrEn, MEM_RegWrEn : in std_logic;
            ID_Rs, ID_Rt : in std_logic_vector(4 downto 0);
            EX_WrReg, MEM_WrReg : in std_logic_vector(4 downto 0);
            AluSrcA, AluSrcB : out std_logic_vector(1 downto 0);
            DataMemForwardCtrl_EX : out std_logic;
            DataMemForwardCtrl_MEM : out std_logic
        );
    end component;

    component PipelineCtrl is

        port (
            EX_Branch : in std_logic;
            EX_Equals : in std_logic;
            ID_Jump : in std_logic;
            ID_Rs, ID_Rt : std_logic_vector(4 downto 0);
            UseShamt, UseImmed : in std_logic;
            EX_MemRdEn : in std_logic;--to detect a load
            EX_WrReg : in std_logic_vector(4 downto 0);
            PCwrite : out std_logic;
            addrSel : out std_logic_vector(1 downto 0);
            Flush_IF_ID, WrEn_IF_ID : out std_logic;
            Flush_ID_EX : out std_logic
        );
    end component;

    -- Declare signals and variables here...
    signal Clk, Rst_L : std_logic;

    -- Typically, the code is easier to read if signals are
    -- declared in the order they appear below...

    -- Instruction fetch signals
    signal IF_ID_Instruction : std_logic_vector(31 downto 0);
    -- Pipeline control signals
    signal Flush_IF_ID, WrEn_IF_ID : std_logic;

    -- Instruction decode signals
    signal ID_Rs, ID_Rt : std_logic_vector(4 downto 0);

    -- Execute stage signals
    signal Shamt : std_logic_vector(31 downto 0);
    signal AluInA : std_logic_vector(31 downto 0);
    signal AluInB : std_logic_vector(31 downto 0);
    signal EX_AluResult : std_logic_vector(31 downto 0);
    signal EX_Equals : std_logic;
    signal EX_RegDst : std_logic;
    signal EX_DataMemWrData : std_logic_vector(31 downto 0);
    signal EX_WrReg : std_logic_vector(4 downto 0);

    --EX/MEM pipeline registers
    signal EX_MEM_MemRdEn, EX_MEM_MemWrEn : std_logic;
    signal EX_MEM_RegSrc : std_logic;
    signal EX_MEM_RegWrEn : std_logic;
    signal EX_MEM_AluResult : std_logic_vector(31 downto 0);
    signal EX_MEM_DataMemWrData : std_logic_vector(31 downto 0);
    signal EX_MEM_WrReg : std_logic_vector(4 downto 0);
    signal EX_MEM_DataMemForwardCtrl_MEM : std_logic;

    --MEM/WB pipeline registers
    signal MEM_WB_RegSrc : std_logic;
    signal MEM_WB_RegWrEn : std_logic;
    signal MEM_WB_DataMemRdData : std_logic_vector(31 downto 0);
    signal MEM_WB_AluResult : std_logic_vector(31 downto 0);
    signal MEM_WB_WrReg : std_logic_vector(4 downto 0);

    -- Write back stage signals
    signal WB_RegWrData : std_logic_vector(31 downto 0);

    --------------------------------------------------------------------------------
begin

    ---------------------------------------------------
    -- Instruction Fetch logic

    -- insert PC logic here, marking the beginning of the fetch stage

    -- IF_ID pipeline registers mark the end of the fetch stage
    process (Clk)
    begin --rising edge triggered logic
        if (Clk’event and Clk = ’1’) then
            if (Flush_IF_ID = ’1’) then --active high, synchronous reset
                IF_ID_Instruction <= (others => ’0’);
                --Add more registers here
            elsif (WrEn_IF_ID = ’1’) then
                IF_ID_Instruction <= Instruction;
                --Add more registers here
            end if;
        end if;
    end process;
    ---------------------------------------------------
    -- Instruction Decode logic

    --break up instruction into parts for readability
    ID_Rs <= IF_ID_Instruction(25 downto 21);
    ID_Rt <= IF_ID_Instruction(20 downto 16);

    --instantiate the register file
    --instance_name: component_name
    -- use nominal port map as opposed to positional!
    Registers : RegisterFile
    port map(
        RdRegA => ID_Rs,
        RdRegB => ID_Rt,
        WrReg => MEM_WB_WrReg,
        Clk => Clk,
        WrData => WB_RegWrData,
        --okay you get the point...
    );

    ---------------------------------------------------
    -- Execute stage logic

    --zero extend the shift amount field
    Shamt(4 downto 0) <= ID_EX_Instruction(10 downto 6);
    Shamt(31 downto 5) <= (others => ’0’);

    -- ALU source mux for OpA
    --The WITH/SELECT/WHEN construct is great for muxes
    with ID_EX_AluSrcA select
        -- the zero extended shamt field
        AluInA <= Shamt when "00",
        -- the bypass path from the write back stage
        WB_RegWrData when "01",
        -- the bypass path from the memory stage
        EX_MEM_AluResult when "10",
        -- the register file output
        ID_EX_RdRegA when others;--avoids latches!

    -- ALU should be instantiated somewhere here...

    -- EX/MEM pipeline registers here...

    ---------------------------------------------------
    -- Memory stage logic
    -- DataMemWrData mux here...
    -- MEM/WB pipeline registers here...

end MIPSpipeline;