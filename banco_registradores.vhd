library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_registradores is
    port (
        clock      : in std_logic;
        reset      : in std_logic;
        reg_write  : in std_logic;
        read_reg1  : in std_logic_vector(4 downto 0);
        read_reg2  : in std_logic_vector(4 downto 0);
        write_reg  : in std_logic_vector(4 downto 0);
        write_data : in std_logic_vector(31 downto 0);
        read_data1 : out std_logic_vector(31 downto 0);
        read_data2 : out std_logic_vector(31 downto 0)
    );
end banco_registradores;

architecture banco_registradores of banco_registradores is
    type regs_t is array (0 to 31) of std_logic_vector(31 downto 0);
    signal regs : regs_t;
begin
    process (clock, reg_write, write_data)
    begin
        if reset = '1' then
            regs <= (3 => x"00000005", others => x"00000000");
        elsif clock'event and clock = '1' then
            if reg_write = '1' then
                if write_reg = "00000" then
                    regs(to_integer(unsigned(write_reg))) <= (others => '0'); 
                else
                    regs(to_integer(unsigned(write_reg))) <= write_data;
                end if;
            end if;
        end if;
    end process;

    read_data1 <= regs(to_integer(unsigned(read_reg1)));
    read_data2 <= regs(to_integer(unsigned(read_reg2)));

end banco_registradores;

        
        
