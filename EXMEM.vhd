library ieee;
use ieee.std_logic_1164.all;

entity EXMEM is
    port (
        clock       : in std_logic;
        reset       : in std_logic;
        e_wb        : in std_logic_vector(1 downto 0);
        e_m         : in std_logic_vector(1 downto 0);
        ej_endereco : in std_logic_vector(31 downto 0);
        e_zero      : in std_logic;
        e_ula       : in std_logic_vector(31 downto 0);       
        e_dado      : in std_logic_vector(31 downto 0);
        e_reg_dst   : in std_logic_vector(4 downto 0);
        s_wb        : out std_logic_vector(1 downto 0);
        s_m         : out std_logic_vector(1 downto 0);
        sj_endereco : out std_logic_vector(31 downto 0);
        s_zero      : out std_logic;
        s_ula       : out std_logic_vector(31 downto 0);       
        s_dado      : out std_logic_vector(31 downto 0);
        s_reg_dst   : out std_logic_vector(4 downto 0)
    );
end EXMEM;

architecture EXMEM of EXMEM is
begin
    process(clock, reset)
    begin
        if reset = '1'then
            s_wb        <= (others => '0'); 
            s_m         <= (others => '0'); 
            sj_endereco <= (others => '0'); 
            s_zero      <= '0'; 
            s_ula       <= (others => '0'); 
            s_dado      <= (others => '0'); 
            s_reg_dst   <= (others => '0');
        elsif clock'event and clock = '1' then
            s_wb        <= e_wb; 
            s_m         <= e_m; 
            sj_endereco <= ej_endereco; 
            s_zero      <= e_zero; 
            s_ula       <= e_ula; 
            s_dado      <= e_dado; 
            s_reg_dst   <= e_reg_dst;
        end if;
    end process;
end EXMEM;
             
      
