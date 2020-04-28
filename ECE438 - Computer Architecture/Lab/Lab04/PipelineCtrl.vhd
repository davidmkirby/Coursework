---------------------------------------------------
-- This component describes the pipeline control unit
-- in our 5-stage, pipelined MIPS processor.

---------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity PipelineCtrl is

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
end PipelineCtrl;

architecture behv of PipelineCtrl is

    begin
    ---------------------------------------------------
    --Pipeline control
    --The sensitivity list! Do something if any of these signals change
    process (UseShamt, ID_Rs, EX_WrReg, MEM_WrReg, EX_RegWrEn, MEM_RegWrEn)
    begin --priority is important!
        --If “Taken” branch instruction is detected in the execute stage
        if (EX_Branch = '1') then
            Flush_IF_ID <= "00";--Flush Fetch stage
        elsif then
        elsif then
        else
        end if;
    end process;

