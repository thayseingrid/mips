library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity busca_instrucao is
    port (
        clock   : in std_logic;
        reset   : in std_logic;
        pc_load : in std_logic; -- pausa o pc quando a instrução for de branch
       	pc_src	 :in std_logic; -- seletor do mux do endereço da proxima instrução
        endereco_salto	: in std_logic_vector(31 downto 0);
        inst    : out std_logic_vector(31 downto 0);
        s_add   : out std_logic_vector(31 downto 0)
    );
end busca_instrucao;

architecture busca_instrucao of busca_instrucao is
    component memoria_instrucao is
    port (
        endereco  : in std_logic_vector(5 downto 0);
        instrucao : out std_logic_vector(31 downto 0)
    );
    end component memoria_instrucao;


    signal pc     : std_logic_vector(31 downto 0);
    signal quatro : std_logic_vector(31 downto 0);
    signal v_add  : std_logic_vector(31 downto 0);
    signal v_endereco_salto  : std_logic_vector(31 downto 0);
    signal v_mux  : std_logic_vector(31 downto 0);
    signal v_mi   : std_logic_vector(31 downto 0);
begin

    quatro <= x"00000001"; 
    v_endereco_salto  <= endereco_salto;
    s_add <= v_add;
    inst <= v_mi;

    process (clock, reset, pc_load, v_mux)
    begin
        if reset = '1' then
            pc <= (others => '0');
        elsif clock'event and clock = '1' then
            if pc_load = '1' then
                pc <= v_mux;
            end if;
        end if;        
    end process;

    process (pc, quatro)
    begin
        v_add <= std_logic_vector(unsigned(pc) + unsigned(quatro));
    end process;

    process (v_add, v_endereco_salto, pc_src)
    begin
        if pc_src = '0' then
            v_mux <= v_add;
        else
            v_mux <= v_endereco_salto;
        end if;
    end process;

    memoria_instrucao_u : memoria_instrucao
    port map (
        endereco => pc(5 downto 0),
        instrucao => v_mi
    );


end busca_instrucao;





