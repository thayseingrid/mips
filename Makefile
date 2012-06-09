all:
	ghdl -i *.vhd
	ghdl -m mips_tb
	ghdl -r mips_tb --stop-time=1us --wave=ondas.ghw

clean:
	rm -rf *.cf *.o *.ghw
