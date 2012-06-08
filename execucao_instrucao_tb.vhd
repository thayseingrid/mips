library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execucao_instrucao_tb is
end execucao_instrucao_tb;

architecture execucao_instrucao_tb of execucao_instrucao_tb is
    component execucao_instrucao is
    port (
        rs_value : in std_logic_vector (31 downto 0);
        rt_value : in std_logic_vector (31 downto 0);
        immdt    : in std_logic_vector (31 downto 0);
        op_alu   : in std_logic_vector (3 downto 0);
        rdReg    : in std_logic_vector (4 downto 0); 
        rtReg    : in std_logic_vector (4 downto 0);
        OrigALU  : in std_logic;
        RegDst   : in std_logic;
        Reg_mux2_out : out std_logic_vector (4 downto 0);
        res      : out std_logic_vector (31 downto 0);
        overflow : out std_logic
    );
    end component execucao_instrucao;

    signal clock : std_logic;

    signal rs_value : std_logic_vector (31 downto 0);
    signal rt_value : std_logic_vector (31 downto 0);
    signal immdt : std_logic_vector (31 downto 0);
    signal op_alu : std_logic_vector (3 downto 0);
    signal rdReg : std_logic_vector (4 downto 0);
    signal rtReg : std_logic_vector (4 downto 0);
    signal OrigALU  : std_logic;
    signal RegDst  : std_logic;
    signal Reg_mux2_out : std_logic_vector (4 downto 0);
    signal res : std_logic_vector (31 downto 0);
    signal overflow : std_logic;
begin

    process
    begin
    	clock <= '1';
    	wait for 5 ns;
    	clock <= '0';
    	wait for 5 ns;
    end process;

    process
    begin
    	rs_value <= x"00000000";
    	rt_value <= x"00100000";
    	immdt    <= x"00000000";
    	op_alu   <= "0000";
    	rdReg    <= "00000";
    	rtReg    <= "00000";
        OrigALU  <= '0';
    	wait until clock'event and clock = '1';

    	rs_value <= x"00000000";
    	rt_value <= x"00100000";
    	immdt    <= x"00000000";
    	op_alu   <= "0000";
    	rdReg    <= "00000";
    	rtReg    <= "00000";
        OrigALU  <= '0';
    	wait until clock'event and clock = '1';

    	wait;
    end process;

    execucao_instrucao_u : execucao_instrucao
    port map (rs_value, rt_value, immdt, op_alu, rdReg, rtReg, 
        OrigALU, RegDst, Reg_mux2_out, res, overflow);
end execucao_instrucao_tb;






