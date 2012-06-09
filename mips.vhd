library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips is
    port (
        clock : in std_logic;
        reset : in std_logic;
        res   : out std_logic_vector(31 downto 0)
    );
end mips;

architecture mips of mips is
    component IFID is
    port (
        clock  : in std_logic;
        reset  : in std_logic;
        inst   : in std_logic_vector(31 downto 0);
        ev_pc  : in std_logic_vector(31 downto 0);
        opcode : out std_logic_vector(5 downto 0);
        rs     : out std_logic_vector(4 downto 0);
        rt     : out std_logic_vector(4 downto 0);
        rd     : out std_logic_vector(4 downto 0);
        shamt  : out std_logic_vector(4 downto 0);
        funct  : out std_logic_vector(5 downto 0);
        immd   : out std_logic_vector(15 downto 0);
        target : out std_logic_vector(25 downto 0);
        sv_pc  : out std_logic_vector(31 downto 0)
    );
    end component IFID;

    component IDEX is
    port (
        clock   : in std_logic;
        reset   : in std_logic;
        e_wb    : in std_logic_vector(1 downto 0);
        e_m     : in std_logic_vector(1 downto 0);
        e_ex    : in std_logic_vector(5 downto 0);
        ev_pc   : in std_logic_vector(31 downto 0);
        ev_rs   : in std_logic_vector(31 downto 0);
        ev_rt   : in std_logic_vector(31 downto 0);
        e_immd  : in std_logic_vector(31 downto 0);
        e_rd    : in std_logic_vector(5 downto 0);
        e_rt    : in std_logic_vector(5 downto 0);
        s_wb    : out std_logic_vector(1 downto 0);
        s_m     : out std_logic_vector(1 downto 0);
        s_ex    : out std_logic_vector(5 downto 0);
        sv_pc   : out std_logic_vector(31 downto 0);
        sv_rs   : out std_logic_vector(31 downto 0);
        sv_rt   : out std_logic_vector(31 downto 0);
        s_immd  : out std_logic_vector(31 downto 0);
        s_rd    : out std_logic_vector(5 downto 0);
        s_rt    : out std_logic_vector(5 downto 0)
    );
    end component IDEX;

    component EXMEM is
    port (
        clock       : in std_logic;
        reset       : in std_logic;
        e_wb        : in std_logic_vector(1 downto 0);
        e_m         : in std_logic_vector(1 downto 0);
        ej_endereco : in std_logic_vector(31 downto 0);
        e_zero      : in std_logic;
        e_ula       : in std_logic_vector(31 downto 0);       
        e_dado      : in std_logic_vector(31 downto 0);
        e_reg_dst   : in std_logic_vector(4 downto 0);
        s_wb        : out std_logic_vector(1 downto 0);
        s_m         : out std_logic_vector(1 downto 0);
        sj_endereco : out std_logic_vector(31 downto 0);
        s_zero      : out std_logic;
        s_ula       : out std_logic_vector(31 downto 0);       
        s_dado      : out std_logic_vector(31 downto 0);
        s_reg_dst   : out std_logic_vector(4 downto 0)
    );
    end component EXMEM;

    component MEMWB is
    port (
        clock       : in std_logic;
        reset       : in std_logic;
        e_wb        : in std_logic_vector(1 downto 0);
        e_memoria   : in std_logic_vector(31 downto 0);
        e_ula       : in std_logic_vector(31 downto 0);
        e_reg_dst   : in std_logic_vector(4 downto 0);
        s_wb        : out std_logic_vector(1 downto 0);
        s_memoria   : out std_logic_vector(31 downto 0);
        s_ula       : out std_logic_vector(31 downto 0);
        s_reg_dst   : out std_logic_vector(4 downto 0)
    );
    end component MEMWB;


    component busca_instrucao is
    port (
        clock   : in std_logic;
        reset   : in std_logic;
        pc_load : in std_logic; -- pausa o pc
        pc_src  : in std_logic; -- seletor do mux
        e_res   : in std_logic_vector(31 downto 0);
        inst    : out std_logic_vector(31 downto 0);
        s_add   : out std_logic_vector(31 downto 0)
    );
    end component busca_instrucao;

    component estagio_decodificacao is
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
        target      : in std_logic_vector(25 downto 0);
        s_wb        : out std_logic_vector(1 downto 0);
        s_m         : out std_logic_vector(1 downto 0);
        s_ex        : out std_logic_vector(5 downto 0);
        sv_pc       : out std_logic_vector(31 downto 0);
        read_data1  : out std_logic_vector(31 downto 0);
        read_data2  : out std_logic_vector(31 downto 0);
        s_rt        : out std_logic_vector(4 downto 0);
        s_rd        : out std_logic_vector(4 downto 0);
        s_immd      : out std_logic_vector(31 downto 0)
    );
    end component estagio_decodificacao;

    component execucao_instrucao is 
    port (
        rs_value : in std_logic_vector (31 downto 0);
        rt_value : in std_logic_vector (31 downto 0);
        immdt    : in std_logic_vector (31 downto 0);
        op_alu   : in std_logic_vector (3 downto 0);
        rdReg    : in std_logic_vector (4 downto 0); 
        rtReg    : in std_logic_vector (4 downto 0);
        OrigALU  : in std_logic;
        RegDst   : in std_logic;
        Reg_mux2_out : out std_logic_vector (4 downto 0);
        res      : out std_logic_vector (31 downto 0);
        overflow : out std_logic
    );
    end component execucao_instrucao;

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

    component escrita_resultado is
    port (
        e_dm    : in std_logic_vector(31 downto 0);
        e_alu   : in std_logic_vector(31 downto 0);
        e_reg   : in std_logic_vector(4 downto 0);
        e_wb1   : in std_logic;
        e_wb2   : in std_logic;
        s_mux   : out std_logic_vector(31 downto 0);
        s_reg   : out std_logic_vector(4 downto 0);
        s_wb2   : out std_logic
    );
    end component escrita_resultado;

begin
    busca_instrucao_u : busca_instrucao
    port map (
        clock => clock,
        reset => reset,
        pc_load 
        pc_src 
        e_res 
        inst 
        s_add 
    );

    IFID_U : IFID
    port map (
        clock => clock,  
        reset => reset,
        inst 
        ev_pc 
        opcode 
        rs
        rt
        rd
        shamt 
        funct
        immd
        target 
        sv_pc 
    ); 

    estagio_decodificacao_u : estagio_decodificacao
    port map (
        clock => clock,
        reset => reset,
        regwrite 
        ev_pc
        opcode
        rs
        e_rt
        e_rd
        shamt
        funct
        e_immd
        write_reg
        write_data
        target
        s_wb
        s_m
        s_ex
        sv_pc
        read_data1
        read_data2
        s_rt
        s_rd
        s_immd
    );

    IDEX_U : IDEX
    port map (
        clock => clock,
        reset => reset,
        e_wb 
        e_m 
        e_ex    
        ev_pc  
        ev_rs 
        ev_rt   
        e_immd 
        e_rd  
        e_rt    
        s_wb   
        s_m   
        s_ex 
        sv_pc   
        sv_rs  
        sv_rt 
        s_immd  
        s_rd   
        s_rt  
    );

    execucao_instrucao_u : execucao_instrucao
    port map (
        rs_value 
        rt_value 
        immdt    
        op_alu   
        rdReg   
        rtReg    
        OrigALU  
        RegDst   
        Reg_mux2_out 
        res      
        overflow 
    );

    EXMEM_U : EXMEM
    port map (
        clock => clock,
        reset => reset,     
        e_wb       
        e_m       
        ej_endereco 
        e_zero      
        e_ula       
        e_dado      
        e_reg_dst   
        s_wb        
        s_m         
        sj_endereco 
        s_zero      
        s_ula       
        s_dado      
        s_reg_dst   
    );

    

    estagio_memoria_u : estagio_memoria
    port map (
        clock => clock, 
        e_wb        
        e_m        
        ej_endereco 
        e_zero      
        e_ula       
        e_dado      
        e_reg_dst   
        sj_endereco 
        pcsrc      
        s_wb      
        s_memoria
        s_ula   
        s_reg_dst 
    );

    MEMWB_U : MEMWB
    port map (
        clock => clock,
        reset => reset,
        e_wb        
        e_memoria   
        e_ula      
        e_reg_dst 
        s_wb        
        s_memoria   
        s_ula       
        s_reg_dst 
    );

    escrita_resultado_u : escrita_resultado
    port map (
        e_dm 
        e_alu   
        e_reg   
        e_wb1   
        e_wb2   
        s_mux   
        s_reg   
        s_wb2   
    );
 


end mips;












