vlib work
vmap work


vcom -work work -93 -explicit memoria_dados.vhd
vcom -work work -93 -explicit estagio_memoria.vhd
vcom -work work -93 -explicit estagio_memoria_tb.vhd



vsim -t 1ns -lib work estagio_memoria_tb



add wave -noupdate -format Logic -radix binary /estagio_memoria_tb/clock

add wave -noupdate -format Literal -radix binary /estagio_memoria_tb/e_wb

add wave -noupdate -format Literal -radix binary /estagio_memoria_tb/e_m

add wave -noupdate -format Literal -radix decimal /estagio_memoria_tb/ej_endereco

add wave -noupdate -format Literal -radix binary /estagio_memoria_tb/e_zero

add wave -noupdate -format Literal -radix decimal /estagio_memoria_tb/e_ula

add wave -noupdate -format Literal -radix decimal /estagio_memoria_tb/e_dado

add wave -noupdate -format Literal -radix binary /estagio_memoria_tb/e_reg_dst

add wave -noupdate -format Literal -radix decimal /estagio_memoria_tb/sj_endereco

add wave -noupdate -format Literal -radix binary /estagio_memoria_tb/pcsrc

add wave -noupdate -format Literal -radix binary /estagio_memoria_tb/s_wb

add wave -noupdate -format Literal -radix decimal /estagio_memoria_tb/s_memoria

add wave -noupdate -format Literal -radix binary /estagio_memoria_tb/S_ula

add wave -noupdate -format Literal -radix binary /estagio_memoria_tb/s_reg_dst

view wave

run 500ns
