library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria_dados is
    port (
        clock : in std_logic;
        load  : in std_logic;
        endereco : in std_logic_vector(5 downto 0);
        v_in  : in std_logic_vector(31 downto 0);
        v_out : out std_logic_vector(31 downto 0)
    );
end memoria_dados;

architecture memoria_dados of memoria_dados is
    type tipo_ram is array (0 to 63) of std_logic_vector(31 downto 0);
    signal ram : tipo_ram;
   
begin
    -- processs de escrita
    process (clock, v_in, endereco)
    begin
        if clock'event and clock = '1' then
            if load = '1' then
                ram(to_integer(unsigned(endereco))) <= v_in; --ram[endereco] = v_in
            end if;
        end if;

        v_out <= ram(to_integer(unsigned(endereco)));
    end process;
end memoria_dados;

