library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity estagio_decodificacao is
    port (
        clock       : in std_logic;
        reset       : in std_logic;
        regwrite    : in std_logic;
        ev_pc       : in std_logic_vector(31 downto 0);        
        opcode      : in std_logic_vector(5 downto 0);
        rs          : in std_logic_vector(4 downto 0);
        e_rt        : in std_logic_vector(4 downto 0);
        e_rd        : in std_logic_vector(4 downto 0);
        shamt       : in std_logic_vector(4 downto 0);
        funct       : in std_logic_vector(5 downto 0);
        e_immd      : in std_logic_vector(15 downto 0);
        write_reg   : in std_logic_vector(4 downto 0);
        write_data  : in std_logic_vector(31 downto 0);
        e_target    : in std_logic_vector(25 downto 0);
        s_wb        : out std_logic_vector(1 downto 0);
        s_m         : out std_logic_vector(1 downto 0);
        s_ex        : out std_logic_vector(5 downto 0);
        s_ex2       : out std_logic;
        sv_pc       : out std_logic_vector(31 downto 0);
        read_data1  : out std_logic_vector(31 downto 0);
        read_data2  : out std_logic_vector(31 downto 0);
        s_rt        : out std_logic_vector(4 downto 0);
        s_rd        : out std_logic_vector(4 downto 0);
        s_immd      : out std_logic_vector(31 downto 0);
        s_target    : out std_logic_vector(31 downto 0)
    );
end estagio_decodificacao;

architecture estagio_decodificacao of estagio_decodificacao is
component banco_registradores is
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
end component banco_registradores;

begin
    sv_pc <= ev_pc;
    s_rt  <= e_rt;
    s_rd  <= e_rd;

    -- extensao de sinal para o immd
    process(e_immd)
    begin
        if e_immd(15) = '1' then
            s_immd <= x"FFFF" & e_immd;
        else 
            s_immd <= x"0000" & e_immd;
        end if;
    end process;
    
    -- extensao de sinal para o target
    process(e_target)
    begin
        if e_target(25) = '1' then
            s_target <= "111111" & e_target;
        else 
            s_target <= "000000" & e_target;
        end if;
    end process;

    -- controle
    process(opcode, shamt, funct)
    begin
        if opcode = "000000" then
            if shamt = "00000" and funct = "100000" then
                s_ex <= "100100"; -- código da adição
                s_m  <= "00";
                s_wb <= "10";
            elsif shamt = "00000" and funct = "100010" then 
                s_ex <= "101100"; -- código da subtração (será enviado para a ula)
                s_m <= "00";
                s_wb <= "10";
              elsif shamt = "00000" and funct = "100100" then 
                s_ex <= "100000"; -- código do AND
                s_m <= "00";
                s_wb <= "10";
              elsif shamt = "00000" and funct = "100101" then
                s_ex <= "100010"; -- código do OR
                s_m <= "00";
                s_wb <= "10";
              elsif shamt = "00000" and funct = "101010" then
                s_ex <= "101110"; -- código do SLT (set on less than)
                s_m <= "00";
                s_wb <= "10";
            end if;
	
        elsif opcode = "001000" then  --addi
            s_ex <= "000101";
            s_m <= "00";
            s_wb <= "10";
        elsif opcode = "100011" then --lw
            s_ex <= "000101";
            s_m <= "00";
            s_wb <= "11";
        elsif opcode = "101011" then --sw
            s_ex <= "000101"; 
            s_m <= "01";
            s_wb <= "00";
        else
            s_ex <= "000000";
            s_m  <= "00";
            s_wb <= "00"; 
        end if;
    end process;

    banco_registradores_u : banco_registradores
    port map (
        clock      => clock,
        reset      => reset,
        reg_write  => regwrite,
        read_reg1  => rs,
        read_reg2  => e_rt,
        write_reg  => write_reg,
        write_data => write_data,
        read_data1 => read_data1,
        read_data2 => read_data2
    );
        
end estagio_decodificacao;

