--test bench 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


entity testbench is
end testbench;


architecture behavioral of testbench	is

file 	file_result_out 	:	text;
file	file_input_in		:	text;


signal	clk,rst											: 	std_logic						:='0';
signal	valid											: 	std_logic						:='0';
signal	opcode 											:	std_logic_vector(3 downto	0)	:=(others=>'0');
signal	AC,B,C,D,BUS_value								:	unsigned(31 downto 0)			:=(others=>'0');
signal	AC_int,B_int,C_int,D_int,BUS_value_int			:	std_logic_vector(31 downto 0)			:=(others=>'0');

constant	output_text					:	std_logic_vector(3 downto 0)		:="1010";

begin



inst_main: entity work.simple_integer_unit
port map(
clk				=>clk,
rst				=>rst,
opcode 			=>opcode,
AC				=>AC,
B				=>B,
C				=>C,
D				=>D,
BUS_value		=>BUS_value,
valid			=>valid
);


clk 	<=	not(clk) after 10 ns;

AC_int			<=	std_logic_vector(AC);
B_int			<=	std_logic_vector(B);
C_int			<=	std_logic_vector(C);
D_int			<=	std_logic_vector(D);
BUS_value_int	<=	std_logic_vector(BUS_value);






-- read opcode from file
process

variable	in_line			: line;
variable 	term_in1		: std_logic_vector(3 downto 0);
variable 	term_out1		: std_logic_vector(3 downto 0);
variable 	out_line 	    : line;	--this line will be written into file
	
begin
	
	
	file_open(file_input_in,"C:\Users\Asus\Documents\[HW7][erfan_rafiee_98243027][farbod_fooladi_98243045][GROUP_20]\opcode_input.txt",read_mode);
	file_open(file_result_out,"C:\Users\Asus\Documents\[HW7][erfan_rafiee_98243027][farbod_fooladi_98243045][GROUP_20]\output_results.txt", write_mode);
			
	while not(endfile(file_input_in)) loop

	readline(file_input_in,in_line);			
	read(in_line,term_in1);

	opcode	<=	term_in1;
	
	wait until rising_edge(valid);

	write(out_line,AC_int);
	write(out_line,' ');
	write(out_line,BUS_value_int);
	write(out_line,' ');
	write(out_line,C_int);
	write(out_line,' ');
	write(out_line,D_int);
    writeline(file_result_out,out_line);
		
	end loop;

	file_close(file_result_out);
	file_close(file_input_in);

end process;



end behavioral;






















