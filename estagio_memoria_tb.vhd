library ieee;
use ieee.std_logic_1164.all;

entity estagio_memoria_tb is
end estagio_memoria_tb;

architecture estagio_memoria_tb of estagio_memoria_tb is
    component estagio_memoria is
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
    end component estagio_memoria;

    signal clock       : std_logic;
    signal e_wb        : std_logic_vector(1 downto 0);
    signal e_m         : std_logic_vector(1 downto 0);
    signal ej_endereco : std_logic_vector(31 downto 0);
    signal e_zero      : std_logic;
    signal e_ula       : std_logic_vector(31 downto 0);
    signal e_dado      : std_logic_vector(31 downto 0);
    signal e_reg_dst   : std_logic_vector(4 downto 0);
    signal sj_endereco : std_logic_vector(31 downto 0);
    signal pcsrc       : std_logic;
    signal s_wb        : std_logic_vector(1 downto 0);
    signal s_memoria   : std_logic_vector(31 downto 0);    
    signal s_ula       : std_logic_vector(31 downto 0);
    signal s_reg_dst   : std_logic_vector(4 downto 0);

begin
    process
    begin
        clock <= '1';
        wait for 5 ns;
        clock <= '0';
        wait for 5 ns;
    end process;

    process
    begin
        e_wb        <= "00";
        e_m         <= "00";
        ej_endereco <= "00000000000000000000000000000000";
        e_zero      <= '0';
        e_ula       <= "00000000000000000000000000000000";
        e_dado      <= "00000000000000000000000000000000";
        e_reg_dst   <= "00000";
        wait until clock'event and clock = '1';

        e_wb        <= "00";
        e_m         <= "00";
        ej_endereco <= "00000000000000000000000000000000";
        e_zero      <= '0';
        e_ula       <= "00000000000000000000000000000000";
        e_dado      <= "00000000000000000000000000000000";
        e_reg_dst   <= "00000";
        wait until clock'event and clock = '1';


        -- store r5, 0(r7)     r5 = 0; r7 = 3;
        e_wb        <= "01";
        e_m         <= "01";
        ej_endereco <= "00000000000000000000000000000000";
        e_zero      <= '0';
        e_ula       <= "00000000000000000000000000000011";
        e_dado      <= "00000000000000000000000000000000";
        e_reg_dst   <= "00000";
        wait until clock'event and clock = '1';

        -- lw r1, 0(r7)     r7 = 3;
        e_wb        <= "11";
        e_m         <= "00";
        ej_endereco <= "00000000000000000000000000000000";
        e_zero      <= '0';
        e_ula       <= "00000000000000000000000000000011";
        e_dado      <= "00000000000000000000000000000000";
        e_reg_dst   <= "00001";
        wait until clock'event and clock = '1';

        e_wb        <= "00";
        e_m         <= "00";
        ej_endereco <= "00000000000000000000000000000000";
        e_zero      <= '0';
        e_ula       <= "00000000000000000000000000000000";
        e_dado      <= "00000000000000000000000000000000";
        e_reg_dst   <= "00000";
        wait until clock'event and clock = '1';

        wait;
    end process;

    estagio_memoria_u : estagio_memoria
    port map (
        clock, e_wb, e_m, ej_endereco, e_zero, e_ula, 
        e_dado, e_reg_dst, sj_endereco, pcsrc, s_wb, 
        s_memoria, s_ula, s_reg_dst
    );
end estagio_memoria_tb;
