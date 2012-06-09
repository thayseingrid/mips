library ieee;
use ieee.std_logic_1164.all ;

entity IDEX is
    port (
        clock   : in std_logic;
        reset   : in std_logic;
        e_wb    : in std_logic_vector(1 downto 0);
        e_m     : in std_logic_vector(1 downto 0);
        e_ex    : in std_logic_vector(5 downto 0);
        ev_pc   : in std_logic_vector(31 downto 0);
        ev_rs   : in std_logic_vector(31 downto 0);
        ev_rt   : in std_logic_vector(31 downto 0);
        e_immd  : in std_logic_vector(31 downto 0);
        e_rd    : in std_logic_vector(4 downto 0);
        e_rt    : in std_logic_vector(4 downto 0);
        s_wb    : out std_logic_vector(1 downto 0);
        s_m     : out std_logic_vector(1 downto 0);
        s_ex    : out std_logic_vector(5 downto 0);
        sv_pc   : out std_logic_vector(31 downto 0);
        sv_rs   : out std_logic_vector(31 downto 0);
        sv_rt   : out std_logic_vector(31 downto 0);
        s_immd  : out std_logic_vector(31 downto 0);
        s_rd    : out std_logic_vector(4 downto 0);
        s_rt    : out std_logic_vector(4 downto 0)
    );
end IDEX;

architecture IDEX of IDEX is
begin
    process(clock, reset)
    begin
        if reset = '1' then
            s_wb    <= (others => '0'); 
            s_m     <= (others => '0');
            s_ex    <= (others => '0');
            sv_pc   <= (others => '0'); 
            sv_rs   <= (others => '0');
            sv_rt   <= (others => '0'); 
            s_immd  <= (others => '0'); 
            s_rd    <= (others => '0'); 
            s_rt    <= (others => '0');
        elsif clock'event and clock = '1' then
            s_wb    <= e_wb;
            s_m     <= e_m;
            s_ex    <= e_ex;
            sv_pc   <= ev_pc; 
            sv_rs   <= ev_rs;
            sv_rt   <= ev_rt; 
            s_immd  <= e_immd; 
            s_rd    <= e_rd; 
            s_rt    <= e_rt;
        end if;
    end process;
end IDEX;

