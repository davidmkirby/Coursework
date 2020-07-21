---------------------------------------------------
-- This component describes the forwarding unit in our
-- 5-stage, pipelined MIPS processor.
---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------
entity ForwardingUnit is

    port (
        UseShamt, UseImmed : in std_logic;
        EX_RegWrEn, MEM_RegWrEn : in std_logic;
        ID_Rs, ID_Rt : in std_logic_vector(4 downto 0);
        EX_WrReg, MEM_WrReg : in std_logic_vector(4 downto 0);
        AluSrcA, AluSrcB : out std_logic_vector(1 downto 0);
        DataMemForwardCtrl_EX : out std_logic;
        DataMemForwardCtrl_MEM : out std_logic
    );
end ForwardingUnit;
---------------------------------------------------

architecture behv of ForwardingUnit is

begin
    ---------------------------------------------------
    --forwarding logic for ALU operand A
    --The sensitivity list! Do something if any of these signals change
    process (UseShamt, ID_Rs, EX_WrReg, MEM_WrReg, EX_RegWrEn, MEM_RegWrEn)
    begin --priority is important!
        --If shift amount instruction, don't forward
        if (UseShamt = '1') then
            AluSrcA <= "00";--use shift amount
            --else if data is produced by instruction one stage ahead
        elsif ((EX_RegWrEn = '1') and (ID_Rs = EX_WrReg) and (EX_WrReg /= b"00000")) then
            AluSrcA <= "10";--use EX bypass
            --else if data is produced by instruction two stages ahead
        elsif ((MEM_RegWrEn = '1') and (ID_Rs = MEM_WrReg) and (MEM_WrReg /= b"00000")) then
            AluSrcA <= "01";--use MEM bypass
        else
            --else if data is produced by instruction in WB or beyond
            AluSrcA <= "11";--pull from Register file
        end if;
    end process;

    ---------------------------------------------------
    --forwarding logic for ALU operand B
    --The sensitivity list! Do something if any of these signals change
    process (UseImmed, ID_Rt, EX_WrReg, MEM_WrReg, EX_RegWrEn, MEM_RegWrEn)
    begin --priority is important!
        --If immediate instruction, don't forward
        if (UseImmed = '1') then
            AluSrcB <= "00";--use immediate
            --else if data is produced by instruction one stage ahead
        elsif ((EX_RegWrEn = '1') and (ID_Rt = EX_WrReg) and (EX_WrReg /= b"00000")) then
            AluSrcB <= "10";--use EX bypass
            --else if data is produced by instruction two stages ahead
        elsif ((MEM_RegWrEn = '1') and (ID_Rt = MEM_WrReg) and (MEM_WrReg /= b"00000")) then
            AluSrcB <= "01";--use MEM bypass
        else
            --else if data is produced by instruction in WB or beyond
            AluSrcB <= "11";--pull from Register file
        end if;
    end process;

    ---------------------------------------------------
    --forwarding logic for data memory
    --The sensitivity list! Do something if any of these signals change
    process (ID_Rt, EX_WrReg, MEM_WrReg, EX_RegWrEn, MEM_RegWrEn)
    begin --priority is important!
        --if data is produced by instruction one stage ahead
        if ((EX_RegWrEn = '1') and (ID_Rt = EX_WrReg) and (EX_WrReg /= b"00000")) then
            DataMemForwardCtrl_EX <= '0';
            DataMemForwardCtrl_MEM <= '1';
            --else if data is produced by instruction two stages ahead
        elsif ((MEM_RegWrEn = '1') and (ID_Rt = MEM_WrReg) and (MEM_WrReg /= b"00000")) then
            DataMemForwardCtrl_EX <= '1';
            DataMemForwardCtrl_MEM <= '0';
            --else if data is produced by instruction in WB or beyond
        else
            DataMemForwardCtrl_EX <= '0';
            DataMemForwardCtrl_MEM <= '0';
        end if;
    end process;
    ---------------------------------------------------
end behv;