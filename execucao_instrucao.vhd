library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
    
entity execucao_instrucao is 
    port (
        e_wb            : in std_logic_vector(1 downto 0);
        e_m             : in std_logic_vector(1 downto 0);
        ex              : in std_logic_vector(5 downto 0);
        v_pc            : in std_logic_vector(31 downto 0);
        read_data1      : in std_logic_vector(31 downto 0);
        read_data2      : in std_logic_vector(31 downto 0);
        immd            : in std_logic_vector (31 downto 0);
        rt              : in std_logic_vector(4 downto 0);
        rd              : in std_logic_vector(4 downto 0);
        s_wb            : out std_logic_vector(1 downto 0);
        s_m             : out std_logic_vector(1 downto 0);
        endereco_salto  : out std_logic_vector(31 downto 0);
        zero            : out std_logic; --ajeitar depois
        ula_res         : out std_logic_vector(31 downto 0);
        s_read_data2    : out std_logic_vector(31 downto 0);
        write_reg       : out std_logic_vector(4 downto 0)
    );
end execucao_instrucao;

architecture execucao_instrucao of execucao_instrucao is
    signal v_op2  : std_logic_vector(31 downto 0);
    signal ALUop  : std_logic_vector(3 downto 0);
    signal ALUsrc : std_logic;
    signal RegDst : std_logic;
begin

    s_wb <= e_wb;
    s_m  <= e_m;
    zero <= '0'; --ajeitar depois
    s_read_data2 <= read_data2;

    process(v_pc, immd)
    begin
        endereco_salto <= std_logic_vector(signed(v_pc) + signed(immd));
    end process;

    ALUsrc <= ex(0);
    process (ALUsrc, read_data2, immd)
    begin
        if ALUsrc = '0' then
            v_op2 <= read_data2;
        else
            v_op2 <= immd;
        end if;
    end process;


    RegDst <= ex(5);
    process (RegDst, rt, rd)
    begin
        if RegDst = '0' then
            write_reg <= rt;
        else
            write_reg <= rd;
        end if;
    end process;




    -- ULA
    ALUop <= ex(4 downto 1);

    process(ex, read_data1, v_op2)
    begin
        if ALUop = "0000" then
            ula_res <= std_logic_vector(signed(read_data1) + signed(v_op2));
        elsif ALUop = "0001" then
            ula_res <= std_logic_vector(signed(read_data1) - signed(v_op2));
        elsif ALUop = "0010" then
            ula_res <= read_data1 and v_op2;
        elsif ALUop = "0011" then
            ula_res <= read_data1 or v_op2;
        elsif ALUop = "0100" then
            ula_res <= not read_data1;
        elsif ALUop = "0101" then
            ula_res <= not v_op2;
        elsif ALUop = "0110" then
            ula_res <= read_data1 xor v_op2;
        elsif ALUop = "0111" then
            ula_res <= read_data1;
        elsif ALUop = "1000" then
            ula_res <= v_op2;
        else 
            ula_res <= v_op2;
        end if;
    end process;

end execucao_instrucao;
-- fim da arquitetura

