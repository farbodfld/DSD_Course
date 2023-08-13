library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_elevator is
end tb_elevator;


architecture testbench of tb_elevator is 

signal	come 					: std_logic_vector(3 downto 0) 		:=(others=>'0');
signal	switch					: std_logic_vector(3 downto 0) 		:=(others=>'0');
signal	cf						: std_logic_vector(3 downto 0) 		:=(others=>'0');
signal	clk						: std_logic 						:='0';
signal	reset					: std_logic 						:='0';
signal	current_floor			: unsigned(2 downto 0) 				:=(others=>'0');
signal	motor_up				: std_logic 						:='0';
signal	motor_down				: std_logic 						:='0';
signal	elevator_state			: std_logic 						:='0';

file 	file_VECTORS 			: text;


begin 

uut :entity work.elevator
port map(
come					=>	come, 
switch					=>	switch,
cf						=>	cf,			
clk						=>	clk,
reset					=>	reset,	
current_floor			=>	current_floor,	
motor_up				=>	motor_up,		
motor_down				=>	motor_down,
elevator_state			=>	elevator_state
);


clk	<=	not clk after 10 ns;

-- switch sensor simulation
switch	<=  "0001" when current_floor ="001" else
			"0010" when current_floor ="010" else
			"0100" when current_floor ="011" else 
			"1000" when current_floor ="100";
			




  process
  
	variable v_ILINE     : line;    
    variable v_ADD_TERM1 : std_logic_vector(3 downto 0);

  begin 
		reset <= '1', '0' after 10 ns;

		file_open(file_VECTORS,"C:\Users\Asus\Documents\[HW6][erfan_rafiee_98243027][farbod_fooladi_98243045][GROUP_20]\elevator_data.txt",read_mode);
	
		while not endfile(file_VECTORS) loop
		
		readline(file_VECTORS, v_ILINE);
		read(v_ILINE, v_ADD_TERM1);
		come  <= v_ADD_TERM1;
	--	cf    <= v_ADD_TERM1;
	
		wait until (switch = come);
		--wait until (switch = cf);
		
		end loop;
		file_close(file_VECTORS);
		reset <='1';
			



 end process;

end testbench;










