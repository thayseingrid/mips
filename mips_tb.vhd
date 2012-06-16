library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips_tb is
end mips_tb;

architecture mips_tb of mips_tb is
    component mips is
    port (
        clock : in std_logic;
        reset : in std_logic;
        res   : out std_logic_vector(31 downto 0)
    );
    end component mips;

    signal clock : std_logic;
    signal reset : std_logic;
    signal res   : std_logic_vector(31 downto 0);
begin
    process
    begin
        clock <= '0';
        wait for 5 ns;
        clock <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        reset <= '1';
        wait for 25 ns;
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait;
    end process;

    mips_u : mips
    port map (
        clock => clock,
        reset => reset,
        res   => res
    );
end mips_tb;


