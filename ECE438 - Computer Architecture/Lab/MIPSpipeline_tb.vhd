------------------------------------------------------------------
-- Test bench for your pipelined MIPS processor
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MIPSpipeline_tb is -- entity declaration has no inputs
end MIPSpipeline_tb;      -- or outputs for test benches

------------------------------------------------------------------

architecture testbench of MIPSpipeline_tb is
   
    --component declaration for Unit Under Test (UUT) 
    component MIPSpipeline
    port( Clk, Rst_L: in std_logic;
        PC: out std_logic_vector(31 downto 0);
        Instruction: in std_logic_vector(31 downto 0);
        DataMemAddr: out std_logic_vector(31 downto 0);
        DataMemRdEn, DataMemWrEn: out std_logic;
        DataMemRdData: in std_logic_vector(31 downto 0);
        DataMemWrData: out std_logic_vector(31 downto 0)
    );
    end component;
    
    --declare clock and reset signals
    signal Clk, Rst_L: std_logic;
   
    -- create vector array for memories 
    type mem_array is array (0 to 63) of
        std_logic_vector (31 downto 0);

    --signals for Instruction memory
    constant InstrMem: mem_array :=(
        0 => X"00004821", --addu $t1, $0, $0
        1 => X"3c08feed", --lui $t0, 0xfeed 
        2 => X"3508beef", --ori $t0, $t0, 0xbeef
        3 => X"ad280000", --sw $t0, 0($t1)
        4 => X"252a0004", --addiu $t2, $t1, 4 
        5 => X"8d2b0000", --lw $t3, 0($t1)
        6 => X"ad4b0000", --sw $t3, 0($t2)
        7 => X"0800000a", --j jumpTarget 
        8 => X"014a5021", --addu $t2, $t2, $t2
        9 => X"31080000", --andi $t0, $t0, 0
--jumpTaget:
        10 => X"ad480000",--sw $t0, 0($t2)
        11 => X"310b0000",--andi $t0, $t3, 0
        12 => X"ad480004",--sw $t0, 4($t2)
        13 => X"00004021",--addu $t0, $0, $0
        14 => X"34090010",--ori $t1, $0, 0x10
        15 => X"016b5826",--$xor $t3, $t3, $t3
--loop:
        16 => X"11090003",--beq $t0, $t1, exitLoop
        17 => X"256b0001",--addiu $t3, $t3, 1
        18 => X"08000010",--j loop
        19 => X"25080001",--addiu $t0, $t0, 1
--exitLoop:
        20 => X"ad480008",--sw $t0, 8($t2)
        21 => X"ad4b000c",--sw $t3, 12($t2)
        22 => X"8d4c000c",--lw $t4, 12($t2)
        23 => X"000c6080",--sll $t4, $t4, 2
        24 => X"ad4c0010",--sw $t4, 16($t2)
        25 => X"000c6842",--srl $t5, $t4, 1
        26 => X"ad4d0014",--sw $t5, 20($t2)
        27 => X"34080001",--ori $t0, $0, 0x1
        28 => X"01004827",--nor $t1, $t0, $0
        29 => X"0109582b",--sltu $t3, $t0, $t1
        30 => X"ad4b0018",--sw $t3, 24($t2)
        31 => X"0128582b",--sltu $t3, $t1, $t0
        32 => X"ad4b001c",--sw $t3, 28($t2)
        33 => X"2d2bffff",--sltiu $t3, $t1, 0xffff
        34 => X"ad4b0020",--sw $t3, 32($t2)
        35 => X"2d0bffff",--sltiu $t3, $t0, 0xffff
        36 => X"ad4b0024",--sw $t3, 36($t2)
        others => X"00000000" --nop
    );
 
    signal PC, Instruction: std_logic_vector(31 downto 0);

    --signals for Data memory
    signal DataMemAddr: std_logic_vector(31 downto 0);
    signal DataMemRdData: std_logic_vector(31 downto 0);
    signal DataMemWrData: std_logic_vector(31 downto 0);
    signal DataMemRdEn, DataMemWrEn: std_logic;
    signal DataMem: mem_array;
    
begin
    
    -- instantiate UUT
    -- use nominal port map as opposed to positional
    UUT: MIPSpipeline
        port map(Clk => Clk,
                 Rst_L => Rst_L,
                 PC => PC,
                 Instruction => Instruction,
                 DataMemAddr => DataMemAddr,
                 DataMemRdEn => DataMemRdEn,
                 DataMemWrEn => DataMemWrEn,
                 DataMemRdData => DataMemRdData,
                 DataMemWrData => DataMemWrData
        );
    
    -- concurrent process to generate a 100MHz clock signal
    process
    begin
        Clk <= '0';
        wait for 5 ns;
        Clk <= '1';
        wait for 5 ns;
    end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 2 clocks.
      Rst_L <= '0';
      wait for 20 ns ;
      Rst_L <= '1';--release processor out of reset

      -- checks will be added here...
    
      wait;
   end process;
   
     -- Instruction ROM read logic
    Instruction <= InstrMem(conv_integer(PC(7 downto 2))); --word aligned

   -- ensure 2 lsb of PC are never nonzero

    -- Data memory synchronous write logic
    process(Clk)--only do something if clock changes
    begin
        --on the rising edge of clock
        if(Clk'event and Clk='1') then
            --only write if enabled 
            if(DataMemWrEn='1') then
                DataMem(conv_integer(DataMemAddr(7 downto 2))) <= DataMemWrData;
            end if;
        end if;
    end process;

    -- Data memory asynchronous read logic
    process(DataMemAddr, DataMemRdEn, DataMem)
    begin
        if(DataMemRdEn='1') then
            DataMemRdData <= DataMem(conv_integer(DataMemAddr(7 downto 2))); --word aligned
        else
            DataMemRdData <= (others => 'Z'); --high impedance out
        end if;
    end process;

end testbench;
