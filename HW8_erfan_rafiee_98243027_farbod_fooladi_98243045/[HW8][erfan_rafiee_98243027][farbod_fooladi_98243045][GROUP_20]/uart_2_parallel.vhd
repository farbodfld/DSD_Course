
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity uart_2_parallel is
    Port ( clk_uart : in  STD_LOGIC;
			  nrst : in  STD_LOGIC;
			  start:in std_logic;
			  data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0):=x"00";
           data_ready : out  STD_LOGIC:='0';
			  tx:out  STD_LOGIC:='0';
			  rx:in  STD_LOGIC:='0');
end uart_2_parallel;
 
architecture Behavioral of uart_2_parallel is


signal reg_start_tx:integer:=0;
signal reg_start_rx:integer:=0;
signal reg_cnt_tx:integer:=0;
signal reg_cnt_rx:integer:=0;
signal reg_data_out:std_logic_vector(7 downto 0 ):=X"00";
begin


A:process(clk_uart,nrst) 
begin
	if(nrst = '0') then
		data_out<=X"00";
		tx<='1';
		data_ready<='0';
		reg_start_tx<=0;
		reg_start_rx<=0;
		reg_cnt_tx<=0;
		reg_cnt_rx<=0;
	elsif(rising_edge(clk_uart)) then
	
		if(reg_start_tx=0) then
			if(start='1') then 
				reg_start_tx<=1;
				reg_cnt_tx<=0;
				tx<='0';
			else 
				reg_start_tx<=0;
				reg_cnt_tx<=0;
				tx<='1';
			end if;
		else
			if(reg_cnt_tx<7) then
				reg_cnt_tx<=reg_cnt_tx+1;
				tx<=data_in(reg_cnt_tx);
			else 
				reg_start_tx<=0;
				tx<='1';		
				reg_cnt_tx<=0;			
			end if;
		end if;
		
		
		if(reg_start_rx=0) then
			if(rx='0') then 
				reg_start_rx<=1;
				reg_cnt_rx<=0;
				data_ready<='0';
			else 
				reg_start_rx<=0;
				reg_cnt_rx<=0;
				data_ready<='0';
			end if;
		else
			if(reg_cnt_rx<8) then
				reg_cnt_rx<=reg_cnt_rx+1;
				reg_data_out(reg_cnt_rx)<=rx;
			else 
				reg_start_rx<=0;
				reg_cnt_rx<=0;		
				data_ready<='1';		
				data_out<=reg_data_out;
			end if;
		end if;
		
		
	end if;
	
	
	
	
	
	
end process;
end Behavioral;

