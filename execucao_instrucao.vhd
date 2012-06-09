library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
    
entity execucao_instrucao is 
    port (
        rs_value : in std_logic_vector (31 downto 0);
        rt_value : in std_logic_vector (31 downto 0);
        immdt    : in std_logic_vector (31 downto 0);
        op_alu   : in std_logic_vector (3 downto 0);
        rdReg    : in std_logic_vector (4 downto 0); 
        rtReg    : in std_logic_vector (4 downto 0);
        OrigALU  : in std_logic;
        RegDst   : in std_logic;
        e_wb     : in std_logic_vector(1 downto 0);
        e_m      : in std_logic_vector(1 downto 0);
        s_wb     : out std_logic_vector(1 downto 0);
        s_m      : out std_logic_vector(1 downto 0);
        write_reg : out std_logic_vector (4 downto 0);
        res      : out std_logic_vector (31 downto 0);
        write_data : out std_logic_vector(31 downto 0);
        overflow : out std_logic
    );
end execucao_instrucao;

architecture execucao_instrucao of execucao_instrucao is
    signal zero : std_logic;
    signal v_op1 : std_logic_vector (31 downto 0);
    signal v_op2 : std_logic_vector (31 downto 0);
    signal v_res : std_logic_vector (31 downto 0);
    signal v_op_alu : std_logic_vector (3 downto 0);
    signal v_mux1_in1 : std_logic_vector (31 downto 0);
    signal v_mux1_in2 : std_logic_vector (31 downto 0);
    signal v_OrigALU : std_logic;
    signal v_mux2_in1 : std_logic_vector (4 downto 0);
    signal v_mux2_in2 : std_logic_vector (4 downto 0);
    signal v_mux2_out : std_logic_vector (4 downto 0);
    signal v_RegDst : std_logic;

begin

    v_op1    <= rs_value;
    v_op_alu <= op_alu;
    res <= v_res;
    overflow <= '0'; --mudar depois!    
    s_wb <= e_wb;
    s_m <= e_m;
    write_data <= rt_value;

    -- ULA
    process(v_op_alu, v_op1, v_op2)
    begin
        if v_op_alu = "0000" then
            v_res <= std_logic_vector(signed(v_op1) + signed(v_op2));
        elsif v_op_alu = "0001" then
            v_res <= std_logic_vector(signed(v_op1) - signed(v_op2));
        elsif v_op_alu = "0010" then
            v_res <= v_op1 and v_op2;
        elsif v_op_alu = "0011" then
            v_res <= v_op1 or v_op2;
        elsif v_op_alu = "0100" then
            v_res <= not v_op1;
        elsif v_op_alu = "0101" then
            v_res <= not v_op2;
        elsif v_op_alu = "0110" then
            v_res <= v_op1 xor v_op2;
        elsif v_op_alu = "0111" then
            v_res <= v_op1;
        elsif v_op_alu = "1000" then
            v_res <= v_op2;
        else 
            v_res <= v_op2;
        end if;
    end process;

    v_mux2_in1 <= rtReg;
    v_mux2_in2 <= rdReg;
    v_RegDst   <= RegDst;

    process (v_RegDst, v_mux2_out, v_mux2_in1, v_mux2_in2)
    begin
        if v_RegDst = '0' then
            v_mux2_out <= v_mux2_in1;
        else
            v_mux2_out <= v_mux2_in2;
        end if;
    end process;
   write_reg <= v_mux2_out;

    v_mux1_in2 <= immdt;
    v_mux1_in1 <= rt_value;
    v_OrigALU <= OrigALU;

    process (v_mux1_in1, v_mux1_in2, v_OrigALU)
    begin
        if v_OrigALU = '0' then
            v_op2 <= v_mux1_in1;
        else
            v_op2 <= v_mux1_in2;
        end if;
    end process;

end execucao_instrucao;
-- fim da arquitetura

