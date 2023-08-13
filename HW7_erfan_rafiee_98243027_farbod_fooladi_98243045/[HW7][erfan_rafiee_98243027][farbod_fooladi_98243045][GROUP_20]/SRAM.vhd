library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SRAM is 
port(
din			:in		unsigned(31 downto 0)	:=(others=>'0');
addr		:in		unsigned(5 downto 0)	:=(others=>'0');
wr			:in		std_logic				:='0';
dout		:out	unsigned(31 downto 0)	:=(others=>'0')
);
end SRAM;


architecture behavioral of SRAM is 

type static_ram	is array (0 to 63) of unsigned(31 downto 0);
signal mem	:	static_ram	:=(others=>(others=>'1'));

begin 


-- write into memory 
mem(to_integer(addr))	<=	din		when wr='1'	else (others=>'0');

-- read from memory 
dout	<=	mem(to_integer(addr)) 	when wr='0' else (others=>'0');


end behavioral;