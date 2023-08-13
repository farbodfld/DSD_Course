library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity clk_divider is
port ( 
	clk: in std_logic;
	Div: in integer; 
	clock_out: out std_logic);
end clk_divider;
  
architecture bhv of clk_divider is
  
signal count: integer:=1;
signal tmp : std_logic := '0';


begin
  
process(clk)
begin

if(clk'event and clk='1') then

	count <=count+1;
	if (count = Div) then
		tmp <= NOT tmp;
		count <= 1;
	end if;
	
end if;

clock_out <= tmp;

end process;
  
end bhv;

