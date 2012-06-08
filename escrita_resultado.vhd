library ieee;
use ieee.std_logic_1164.all;

entity escrita_resultado is
    port (
        e_dm    : in std_logic_vector(31 downto 0);
        e_alu   : in std_logic_vector(31 downto 0);
        e_reg   : in std_logic_vector(4 downto 0);
        e_wb1   : in std_logic;
        e_wb2   : in std_logic;
        s_mux   : out std_logic_vector(31 downto 0);
        s_reg   : out std_logic_vector(4 downto 0);
        s_wb2    : out std_logic
    );
end escrita_resultado;

architecture escrita_resultado of escrita_resultado is
    signal v_dm     : std_logic_vector(31 downto 0);
    signal v_alu    : std_logic_vector(31 downto 0);
    signal v_reg    : std_logic_vector(4 downto 0);
    signal v_wb1    : std_logic;
    signal v_wb2    : std_logic;
    signal v_mux    : std_logic_vector(31 downto 0);
begin
    process(e_wb2)
    begin
        v_wb2 <= e_wb2;
    end process;

    process(e_wb1)
    begin
        v_wb1 <= e_wb1;
    end process;

    process(e_dm)
    begin
        v_dm <= e_dm;
    end process;

    process(e_alu)
    begin
        v_alu <= e_alu;
    end process;

    process(e_reg)
    begin
        v_reg <= e_reg;
    end process;

    process(v_wb1, v_alu, v_dm)
    begin
        if v_wb1 = '1' then
            v_mux <= v_dm;
        else
            v_mux <= v_alu;
        end if;
    end process;

    process(v_reg)
    begin
        s_reg <= v_reg;
    end process;

    process(v_mux)
    begin
        s_mux <= v_mux;
    end process;

    process(v_wb2)
    begin
        s_wb2 <= v_wb2;
    end process;
end escrita_resultado;
