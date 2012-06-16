library ieee;
use ieee.std_logic_1164.all;

entity IFID is
    port (
        clock  : in std_logic;
        reset  : in std_logic;
        inst   : in std_logic_vector(31 downto 0);
        ev_pc  : in std_logic_vector(31 downto 0); -- saída de (pc+4), entrada no IFID
        opcode : out std_logic_vector(5 downto 0);
        rs     : out std_logic_vector(4 downto 0);
        rt     : out std_logic_vector(4 downto 0);
        rd     : out std_logic_vector(4 downto 0);
        shamt  : out std_logic_vector(4 downto 0);
        funct  : out std_logic_vector(5 downto 0);
        immd   : out std_logic_vector(15 downto 0);
        target : out std_logic_vector(25 downto 0);
        sv_pc  : out std_logic_vector(31 downto 0)
    );
end IFID;

architecture IFID of IFID is
begin
    process(clock, reset, inst, ev_pc)
    begin 
        if reset = '1' then
            opcode <= (others => '0');
            rs     <= (others => '0');
            rt     <= (others => '0');
            rd     <= (others => '0');
            shamt  <= (others => '0');
            funct  <= (others => '0');
            immd   <= (others => '0');
            target <= (others => '0');
            sv_pc  <= (others => '0');
        elsif clock'event and clock = '1' then
            opcode  <= inst(31 downto 26);
            rs      <= inst(25 downto 21);
            rt      <= inst(20 downto 16);
            rd      <= inst(15 downto 11);
            shamt   <= inst(10 downto 6);
            funct   <= inst(5 downto 0);
            immd    <= inst(15 downto 0);
            target  <= inst(25 downto 0);
        end if;            
    end process;
end IFID;
