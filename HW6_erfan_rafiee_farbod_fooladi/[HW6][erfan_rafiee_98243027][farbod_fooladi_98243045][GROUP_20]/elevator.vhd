library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity elevator is
port(
come, 	 	--user out of elevator
cf,			--user inside of elevator 		
switch									:in		 std_logic_vector(3 downto 0) 	:=(others=>'0');  --detect elevator position
clk,reset								:in		 std_logic 						:='0';
current_floor							:out	 unsigned(2 downto 0) 			:=(others=>'0');
motor_up,motor_down,elevator_state		:out	 std_logic 						:='0'
);
end elevator;


architecture Beahavioral of elevator is 

signal	current_floor_int,next_floor_int							:	unsigned(2 downto 0)			:=(others=>'0');
signal	low_key							:	unsigned(2 downto 0)			:="001";
signal	high_key						:	unsigned(2 downto 0)			:="100";
signal	next_floor													:	std_logic_vector(3 downto 0)	:=(others=>'0');
signal	elevator_state_int,motor_down_int,motor_up_int				:	std_logic						:='0';
signal	counter 													:	integer							:=0;


begin 


elevator_state	<=	elevator_state_int;
motor_down		<=	motor_down_int;
motor_up		<=	motor_up_int;
current_floor	<=	current_floor_int;



process(clk)
begin
if (next_floor_int > current_floor_int) then

			motor_up_int			<=	'1';
			motor_down_int			<=	'0';
			elevator_state_int		<=	'1';
	end if;
						
	if (next_floor_int < current_floor_int) then

			motor_up_int			<=	'0';
			motor_down_int			<=	'1';
			elevator_state_int		<=	'1';
			
	end if;
	
	if(next_floor_int = current_floor_int) then
			motor_up_int		<=	'0';
			motor_down_int		<=	'0';
			elevator_state_int	<=	'0';

	end if;

if (reset='1') then 

	motor_down_int		<=	'0';
	motor_up_int		<=	'0';
	elevator_state_int	<=	'0';
	current_floor_int	<= 	"000";

elsif(rising_edge(clk)) then

	if (elevator_state_int='0') then
		next_floor	<= come; --outside 
	--if(elevator_state_int='0') then
	--	next_floor	<= cf; --inside
	end if;

	if (elevator_state_int = '1') then 
		counter	<=	counter + 1;
	end if;
	
	case next_floor is 

			when "0001"	=> 	next_floor_int <= "001";									
			when "0010"	=>  next_floor_int <= "010";
			when "0100"	=>  next_floor_int <= "011";
			when "1000"	=> 	next_floor_int <= "100";
			when others	=>  next_floor_int <= "000";

	end case;	


	if (counter <= 20 and motor_down_int ='1') then 
		if( current_floor_int > low_key ) then
			current_floor_int <= current_floor_int - 1;
			counter <= 0;
		end if;
	end if;
			
	if(counter <= 20 and motor_up_int ='1') then
		if( current_floor_int < high_key ) then 
			current_floor_int <= current_floor_int + 1;
			counter <= 0;
		end if;
	end if;





end if;
end  process;


end Beahavioral;









