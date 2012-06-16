library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips is
    port (
        clock : in std_logic;
        reset : in std_logic
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
        e_ex2   : in std_logic;
        ev_pc   : in std_logic_vector(31 downto 0);
        ev_rs   : in std_logic_vector(31 downto 0);
        ev_rt   : in std_logic_vector(31 downto 0);
        e_immd  : in std_logic_vector(31 downto 0);
        e_target : in std_logic_vector(31 downto 0);
        e_rd    : in std_logic_vector(4 downto 0);
        e_rt    : in std_logic_vector(4 downto 0);
        s_wb    : out std_logic_vector(1 downto 0);
        s_m     : out std_logic_vector(1 downto 0);
        s_ex    : out std_logic_vector(5 downto 0);
        s_ex2   : out std_logic;
        sv_pc   : out std_logic_vector(31 downto 0);
        sv_rs   : out std_logic_vector(31 downto 0);
        sv_rt   : out std_logic_vector(31 downto 0);
        s_immd  : out std_logic_vector(31 downto 0);
        s_target : out std_logic_vector(31 downto 0);
        s_rd    : out std_logic_vector(4 downto 0);
        s_rt    : out std_logic_vector(4 downto 0)
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
        endereco_salto   : in std_logic_vector(31 downto 0);
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
    end component estagio_decodificacao;

    component execucao_instrucao is 
    port (
        e_wb            : in std_logic_vector(1 downto 0);
        e_m             : in std_logic_vector(1 downto 0);
        ex              : in std_logic_vector(5 downto 0);
        ex2             : in std_logic;
        v_pc            : in std_logic_vector(31 downto 0);
        read_data1      : in std_logic_vector(31 downto 0);
        read_data2      : in std_logic_vector(31 downto 0);
        immd            : in std_logic_vector(31 downto 0);
        target          : in std_logic_vector(31 downto 0);
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
        wb      : in std_logic_vector(1 downto 0);
        memoria : in std_logic_vector(31 downto 0);
        ula     : in std_logic_vector(31 downto 0);
        e_write_reg : in std_logic_vector(4 downto 0);
        reg_write : out std_logic;
        write_data : out std_logic_vector(31 downto 0);
        s_write_reg : out std_logic_vector(4 downto 0)
    );
    end component escrita_resultado;

    signal pc_load : std_logic;
    signal pc_src_ifmem : std_logic;
    signal endereco_salto_ifmem : std_logic_vector(31 downto 0); 
    signal inst_if_ifid : std_logic_vector(31 downto 0);

    signal v_pc_if_ifid : std_logic_vector(31 downto 0);
    signal opcode_ifid_id : std_logic_vector(5 downto 0);
    signal rs_ifid_id : std_logic_vector(4 downto 0);
    signal rt_ifid_id : std_logic_vector(4 downto 0);

    signal rd_ifid_id : std_logic_vector(4 downto 0);
    signal shamt_ifid_id : std_logic_vector(4 downto 0);
    signal funct_ifid_id : std_logic_vector(5 downto 0);
    signal immd_ifid_id : std_logic_vector(15 downto 0);

    signal v_pc_ifid_id : std_logic_vector(31 downto 0);
    signal reg_write_id_wb : std_logic;


    signal write_reg_id_wb : std_logic_vector(4 downto 0);
    signal write_data_id_wb : std_logic_vector(31 downto 0);
    signal target_ifid_id : std_logic_vector(25 downto 0);
    signal s_wb_id_idex : std_logic_vector(1 downto 0);
    signal s_m_id_idex : std_logic_vector(1 downto 0);
    signal s_ex_id_idex : std_logic_vector(5 downto 0);
    signal sv_pc_id_idex : std_logic_vector(31 downto 0);
    signal read_data1_id_idex : std_logic_vector(31 downto 0);
    signal read_data2_id_idex : std_logic_vector(31 downto 0);
    signal s_rt_id_idex : std_logic_vector(4 downto 0);
    signal s_rd_id_idex : std_logic_vector(4 downto 0);
    signal s_immd_id_idex : std_logic_vector(31 downto 0);

    signal s_wb_idex_ex : std_logic_vector(1 downto 0);
    signal s_m_idex_ex : std_logic_vector(1 downto 0);
    signal s_ex_idex_ex : std_logic_vector(5 downto 0);
    signal sv_pc_idex_ex : std_logic_vector(31 downto 0);
    signal sv_rs_idex_ex : std_logic_vector(31 downto 0);
    signal sv_rt_idex_ex : std_logic_vector(31 downto 0);
    signal s_immd_idex_ex : std_logic_vector(31 downto 0);
    signal s_rd_idex_ex : std_logic_vector(4 downto 0);
    signal s_rt_idex_ex : std_logic_vector(4 downto 0);

    signal wb_ex_EXMEM : std_logic_vector(1 downto 0);
    signal m_ex_EXMEM : std_logic_vector(1 downto 0);
    signal write_reg_dst_ex_EXMEM : std_logic_vector(4 downto 0);
    signal ula_res_ex_EXMEM : std_logic_vector(31 downto 0);
    signal write_data_ex_EXMEM : std_logic_vector(31 downto 0);
    signal ula_res_EXMEM_mem : std_logic_vector(31 downto 0);
    signal wb_EXMEM_mem : std_logic_vector(1 downto 0);
    signal m_EXMEM_mem : std_logic_vector(1 downto 0);
    signal endereco_salto_EXMEM_mem : std_logic_vector(31 downto 0);
    signal write_reg_EXMEM_mem : std_logic_vector(4 downto 0);
    signal dado_EXMEM_mem : std_logic_vector(31 downto 0);
    signal wb_mem_MEMWB : std_logic_vector(1 downto 0);
    signal memoria_mem_MEMWB : std_logic_vector(31 downto 0);
    signal ula_mem_memwb : std_logic_vector(31 downto 0); 
    signal write_reg_mem_MEMWB : std_logic_vector(4 downto 0);  
    signal ula_MEMWB_wb : std_logic_vector(31 downto 0);
    signal write_reg_MEMWB_wb : std_logic_vector(4 downto 0);
    signal wb_MEMWB_wb : std_logic_vector(1 downto 0); 
    signal memoria_MEMWB_wb : std_logic_vector(31 downto 0);
    
    signal ex2_id_IDEX : std_logic;
    signal ex2_IDEX_ex : std_logic;
    signal target_id_IDEX : std_logic_vector(31 downto 0);
    signal target_IDEX_ex : std_logic_vector(31 downto 0);
    
begin
    pc_load <= '1';

    -- minusculo pra estagio
    -- maiusculo pra registrador
    busca_instrucao_u : busca_instrucao
    port map (
        clock => clock,
        reset => reset,
        pc_load => pc_load,
        pc_src => pc_src_ifmem,
        endereco_salto => endereco_salto_ifmem,
        inst => inst_if_IFID,
        s_add => v_pc_if_IFID
    );

    IFID_U : IFID
    port map (
        clock => clock,  
        reset => reset,
        inst => inst_if_IFID,
        ev_pc => v_pc_if_IFID,
        opcode => opcode_IFID_id, 
        rs => rs_IFID_id,
        rt => rt_IFID_id,
        rd => rd_IFID_id,
        shamt => shamt_IFID_id, 
        funct => funct_IFID_id,
        immd => immd_IFID_id,
        target => target_IFID_id,
        sv_pc => v_pc_IFID_id
    ); 

    estagio_decodificacao_u : estagio_decodificacao
    port map (
        clock => clock,
        reset => reset,
        regwrite => reg_write_id_wb,
        ev_pc => v_pc_IFID_id,
        opcode => opcode_IFID_id,
        rs => rs_IFID_id,
        e_rt => rt_IFID_id,
        e_rd => rd_IFID_id,
        shamt => shamt_IFID_id,
        funct => funct_IFID_id,
        e_immd => immd_IFID_id,
        write_reg => write_reg_id_wb,
        write_data => write_data_id_wb,
        e_target => target_IFID_id,
        s_wb => s_wb_id_IDEX,
        s_m => s_m_id_IDEX,
        s_ex => s_ex_id_IDEX,
        s_ex2 => ex2_id_IDEX,
        sv_pc => sv_pc_id_IDEX,
        read_data1 => read_data1_id_IDEX,
        read_data2 => read_data2_id_IDEX,
        s_rt => s_rt_id_IDEX,
        s_rd => s_rd_id_IDEX,
        s_immd => s_immd_id_IDEX,
        s_target => target_id_IDEX
    );

    IDEX_U : IDEX
    port map (
        clock => clock,
        reset => reset,
        e_wb => s_wb_id_IDEX,
        e_m => s_m_id_IDEX,
        e_ex => s_ex_id_IDEX,
        e_ex2 => ex2_id_IDEX,
        ev_pc => sv_pc_id_IDEX,
        ev_rs => read_data1_id_IDEX,
        ev_rt => read_data2_id_IDEX,
        e_immd => s_immd_id_IDEX,
        e_target => target_id_IDEX,
        e_rd => s_rd_id_IDEX,
        e_rt => s_rt_id_IDEX,
        s_wb => s_wb_IDEX_ex,
        s_m => s_m_IDEX_ex,
        s_ex => s_ex_IDEX_ex,
        s_ex2 => ex2_IDEX_ex,
        sv_pc => sv_pc_IDEX_ex,
        sv_rs => sv_rs_IDEX_ex,
        sv_rt => sv_rt_IDEX_ex,
        s_immd => s_immd_IDEX_ex,
        s_target => target_IDEX_ex,
        s_rd => s_rd_IDEX_ex,
        s_rt => s_rt_IDEX_EX
    );

    execucao_instrucao_u : execucao_instrucao
    port map (
        e_wb => s_wb_IDEX_ex,
        e_m  => s_m_IDEX_ex,
        ex   => s_ex_IDEX_ex,
        ex2  => ex2_IDEX_ex,
        v_pc => (others => '0'), --ajeitar depois
        read_data1 => sv_rs_IDEX_ex,
        read_data2 => sv_rt_IDEX_ex,
        immd => s_immd_IDEX_ex,
        target => target_IDEX_ex,
        rt   => s_rt_IDEX_EX,
        rd   => s_rd_IDEX_ex,
        s_wb => wb_ex_EXMEM,
        s_m  => m_ex_EXMEM,
        endereco_salto => open, -- ajeitar depois
        zero => open, --ajeitar depois
        ula_res => ula_res_ex_EXMEM,
        s_read_data2 => write_data_ex_EXMEM,
        write_reg => write_reg_dst_ex_EXMEM
    );

    EXMEM_U : EXMEM
    port map (
        clock => clock,
        reset => reset,     
        e_wb  => wb_ex_EXMEM,
        e_m   => m_ex_EXMEM,    
        ej_endereco => (others => '0'), -- ajeitar depois!
        e_zero      => '0', -- ajeitar depois!
        e_ula       => ula_res_ex_EXMEM,
        e_dado      => write_data_ex_EXMEM,
        e_reg_dst   => write_reg_dst_ex_EXMEM,
        s_wb        => wb_EXMEM_mem,
        s_m         => m_EXMEM_mem,
        sj_endereco => endereco_salto_EXMEM_mem,
        s_zero      => open, --ajeitar depois
        s_ula       => ula_res_EXMEM_mem,
        s_dado      => dado_EXMEM_mem,
        s_reg_dst   => write_reg_EXMEM_mem
    );

    estagio_memoria_u : estagio_memoria
    port map (
        clock => clock, 
        e_wb  => wb_EXMEM_mem,      
        e_m   => m_EXMEM_mem,   
        ej_endereco => endereco_salto_EXMEM_mem,
        e_zero      => '0', -- ajeitar depois
        e_ula       => ula_res_EXMEM_mem,
        e_dado      => dado_EXMEM_mem,
        e_reg_dst   => write_reg_EXMEM_mem,
        sj_endereco => endereco_salto_ifmem,
        pcsrc => pc_src_ifmem,     
        s_wb  => wb_mem_MEMWB,    
        s_memoria => memoria_mem_MEMWB,
        s_ula     => ula_mem_MEMWB,
        s_reg_dst => write_reg_mem_MEMWB
    );

    MEMWB_U : MEMWB
    port map (
        clock => clock,
        reset => reset,
        e_wb  => wb_mem_MEMWB,
        e_memoria => memoria_mem_MEMWB,  
        e_ula     => ula_mem_MEMWB, 
        e_reg_dst => write_reg_mem_MEMWB,
        s_wb      => wb_MEMWB_wb,  
        s_memoria => memoria_MEMWB_wb,  
        s_ula     => ula_MEMWB_wb,  
        s_reg_dst => write_reg_MEMWB_wb
    );

    escrita_resultado_u : escrita_resultado
    port map (
        wb => wb_MEMWB_wb,
        memoria => memoria_MEMWB_wb,
        ula => ula_MEMWB_wb,
        e_write_reg => write_reg_MEMWB_wb,
        reg_write => reg_write_id_wb,
        write_data => write_data_id_wb,
        s_write_reg => write_reg_id_wb
    );
 


end mips;



