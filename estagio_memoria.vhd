library ieee;
use ieee.std_logic_1164.all;

entity estagio_memoria is
    port (
        clock       : in std_logic;
        e_wb        : in std_logic_vector(1 downto 0);
        e_m         : in std_logic_vector(1 downto 0);
        ej_endereco : in std_logic_vector(31 downto 0);
        e_zero      : in std_logic;
        e_ula       : in std_logic_vector(31 downto 0);
        e_dado      : in std_logic_vector(31 downto 0);
        e_reg_dst   : in std_logic_vector(4 downto 0);
        sj_endereco : out std_logic_vector(31 downto 0);
        pcsrc       : out std_logic;
        s_wb        : out std_logic_vector(1 downto 0);
        s_memoria   : out std_logic_vector(31 downto 0);    
        s_ula       : out std_logic_vector(31 downto 0);
        s_reg_dst   : out std_logic_vector(4 downto 0)
    );
end estagio_memoria;

architecture estagio_memoria of estagio_memoria is
component memoria_dados is
    port (
        clock    : in std_logic;
        load     : in std_logic;
        endereco : in std_logic_vector(5 downto 0);
        v_in     : in std_logic_vector(31 downto 0);
        v_out    : out std_logic_vector(31 downto 0)
    );
end component memoria_dados;

begin
    sj_endereco <= ej_endereco;
    s_wb        <= e_wb;
    s_reg_dst   <= e_reg_dst;
    s_ula       <= e_ula;

    process(e_zero, e_m)
    begin
        pcsrc <= e_zero and e_m(1);
    end process;

    memoria_dados_u : memoria_dados
    port map (
        clock    => clock,
        load     => e_m(0),
        endereco => e_ula(5 downto 0),
        v_in     => e_dado,
        v_out    => s_memoria    
    );

end estagio_memoria;
