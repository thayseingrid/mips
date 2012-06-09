library ieee;
use ieee.std_logic_1164.all;

entity MEMWB;
    port (
        clock       : in std_logic;
        reset       : in std_logic;
        e_wb        : in std_logic_vector(1 downto 0);
        e_memoria   : in std_logic_vector(31 downto 0);
        e_ula       : in std_logic_vector(31 downto 0);
        e_reg_dst   : in std_logic_vector(4 downto 0);
        s_wb        : in std_logic_vector(1 downto 0);
        s_memoria   : in std_logic_vector(31 downto 0);
        s_ula       : in std_logic_vector(31 downto 0);
        s_reg_dst   : in std_logic_vector(4 downto 0)
    );
end MEMWB;

architecture MEMWB of MEMWB is
begin
    process(clock, reset)
    begin
        if reset = '1' then
            s_wb       <= (others => '0'); 
            s_memoria  <= (others => '0'); 
            s_ula      <= (others => '0'); 
            s_reg_dst  <= (others => '0'); 
        elsif clock'event and clock = '1' then
            s_wb       <= e_wb; 
            s_memoria  <= e_memoria;
            s_ula      <= e_ula;
            s_reg_dst  <= e_reg_dst;
        end if;
    end process;
end MEMWB;
 
        
