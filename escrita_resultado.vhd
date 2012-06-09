library ieee;
use ieee.std_logic_1164.all;

entity escrita_resultado is
    port (
        wb      : in std_logic_vector(1 downto 0);
        memoria : in std_logic_vector(31 downto 0);
        ula     : in std_logic_vector(31 downto 0);
        e_write_reg : in std_logic_vector(4 downto 0);
        reg_write : out std_logic;
        write_data : out std_logic_vector(31 downto 0);
        s_write_reg : out std_logic_vector(4 downto 0)
    );
end escrita_resultado;

architecture escrita_resultado of escrita_resultado is
begin
    reg_write <= wb(1);
    
    process(wb, memoria, ula)
    begin
        if wb(0) = '1' then
            write_data <= memoria;
        else
            write_data <= ula;
        end if;
    end process;

    s_write_reg <= e_write_reg;

end escrita_resultado;
