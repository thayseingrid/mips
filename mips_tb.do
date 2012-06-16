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

view wave
run 500ns
