
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 


entity UART_PARALLEL is
    Port ( clk : in  STD_LOGIC;
			  nrst : in  STD_LOGIC;
			  start:in std_logic;
			  data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0):=x"00";
           data_ready : out  STD_LOGIC:='0';
			  tx:out  STD_LOGIC:='0';
			  rx:in  STD_LOGIC:='0';
           buad : in  STD_LOGIC_VECTOR (7 downto 0):=x"00";
			  aclk_out:out STD_LOGIC);
			  
end UART_PARALLEL;

architecture Behavioral of UART_PARALLEL is

COMPONENT clk_divider
	port ( 
		clk: in std_logic;
		Div: in integer; 
		clock_out: out std_logic);
END COMPONENT;

COMPONENT uart_2_parallel
    Port ( clk_uart : in  STD_LOGIC;
			  nrst : in  STD_LOGIC;
			  start:in std_logic;
			  data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0):=x"00";
           data_ready : out  STD_LOGIC:='0';
			  tx:out  STD_LOGIC:='0';
			  rx:in  STD_LOGIC:='0');
END COMPONENT;

signal reg_buad:integer:=0;
signal clk_uart:std_logic;
begin

reg_buad <= to_integer(unsigned(buad));
X1:  clk_divider   PORT MAP(clk,reg_buad,clk_uart);
X2:  uart_2_parallel   PORT MAP(clk_uart,nrst,start,data_in,data_out,data_ready,tx,rx); 
aclk_out<=clk_uart;
end Behavioral;

