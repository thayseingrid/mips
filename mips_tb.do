vlib work
vmap work

vcom -work work -93 -explicit memoria_dados.vhd
vcom -work work -93 -explicit memoria_instrucao.vhd
vcom -work work -93 -explicit banco_registradores.vhd
vcom -work work -93 -explicit IFID.vhd
vcom -work work -93 -explicit IDEX.vhd
vcom -work work -93 -explicit EXMEM.vhd
vcom -work work -93 -explicit MEMWB.vhd
vcom -work work -93 -explicit busca_instrucao.vhd
vcom -work work -93 -explicit estagio_decodificacao.vhd
vcom -work work -93 -explicit execucao_instrucao.vhd
vcom -work work -93 -explicit estagio_memoria.vhd
vcom -work work -93 -explicit escrita_resultado.vhd
vcom -work work -93 -explicit mips.vhd
vcom -work work -93 -explicit mips_tb.vhd


vsim -t 1ns -lib work mips_tb


add wave -noupdate -format Logic -radix binary /mips_tb/clock
add wave -noupdate -format Logic -radix binary /mips_tb/reset

add wave -noupdate -divider -height 32 IF
add wave -noupdate -format Logic -radix binary /mips_tb/mips_u/busca_instrucao_u/pc_load
add wave -noupdate -format Logic -radix binary /mips_tb/mips_u/busca_instrucao_u/pc_src
add wave -noupdate -format Literal -radix decimal /mips_tb/mips_u/busca_instrucao_u/endereco_salto
add wave -noupdate -format Literal -radix decimal /mips_tb/mips_u/busca_instrucao_u/inst
add wave -noupdate -format Literal -radix decimal /mips_tb/mips_u/busca_instrucao_u/s_add

add wave -noupdate -divider -height 32 ID
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/inst
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/regwrite
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/ev_pc
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/opcode
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/rs
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/e_rt
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/e_rd
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/shamt
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/funct
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/e_immd
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/write_reg
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/write_data
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/e_target
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/s_wb
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/s_m
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/s_ex
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/s_ex2
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/sv_pc
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/read_data1
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/read_data2
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/s_rt
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/s_rd
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/s_immd
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/estagio_decodificao_u/s_target

add wave -noupdate -divider -height 32 EX
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/execucao_instrucao/e_wb
add wave -noupdate -format Literal -radix decimal /mips_tb_/mips_u/execucao_instrucao/e_m










view wave
run 10us
