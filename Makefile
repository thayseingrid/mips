all:
	ghdl -a *.vhd

clean:
	rm -rf *.cf *.o *.ghw
