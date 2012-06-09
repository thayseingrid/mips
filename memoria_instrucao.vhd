library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria_instrucao is
    port (
        endereco  : in std_logic_vector(5 downto 0);
        instrucao : out std_logic_vector(31 downto 0)
    );
end memoria_instrucao;

architecture memoria_instrucao of memoria_instrucao is
    type tipo_ram is array (0 to 63) of std_logic_vector(31 downto 0);

    signal ram : tipo_ram;
begin
    ram <= (
        0 => "000000" & "00011" & "00011" & "00010" & "00000" & "100000", --x"12345678",
        1 => x"BABABABA",
        2 => x"00000000",
        others => x"00000000"
    );


    process (endereco)
    begin
        instrucao <= ram(to_integer(unsigned(endereco))); --instrucao = ram[endereco]
    end process;
end memoria_instrucao;
