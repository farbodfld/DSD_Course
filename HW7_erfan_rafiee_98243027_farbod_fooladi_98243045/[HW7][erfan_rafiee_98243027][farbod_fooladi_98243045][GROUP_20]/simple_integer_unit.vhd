--top module 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity simple_integer_unit is
port(
clk,rst				:in 	std_logic						:='0';
valid				:out	std_logic						:='0';
opcode 				:in		std_logic_vector(3  downto 0)	:=(others=>'0');
AC,B,C,D,BUS_value	:out	unsigned(31 downto 0)			:=(others=>'0')
);
end simple_integer_unit;

architecture behavioral of simple_integer_unit is 
-- DATA WIDTH --
constant	reg_32bit			:	integer :=32;
constant	reg_6bit			:	integer :=6;
-- BUFFERING --
signal 		opcode_int			:	std_logic_vector(3 downto 0)			:=(others=>'0');
-- REGISTERS --
signal		REG_A		:	unsigned(reg_6bit-1  downto 0)	:=(others=>'0');
signal		REG_B		:	unsigned(reg_32bit-1  downto 0)	:=(others=>'0'); 
signal		REG_C		:	unsigned(reg_32bit-1  downto 0)	:=(to_unsigned(2465,32));
signal		REG_D		:	unsigned(reg_32bit-1  downto 0)	:=(to_unsigned(351,32));
signal		REG_AC		:	unsigned(reg_32bit-1  downto 0)	:=(others=>'0');
signal 		REG_BUS		:	unsigned(reg_32bit-1 downto 0)	:=(to_unsigned(1051,32));

signal		LD_A			:	std_logic						:='0';
signal		LD_B			:	std_logic						:='0';
signal		LD_C			:	std_logic						:='0';
signal		LD_D			:	std_logic						:='0';
signal		LD_AC			:	std_logic						:='0';
signal		SEL_BUS			:	std_logic_vector(1 downto 0)	:=(others=>'0');
signal		func			:	std_logic_vector(2 downto 0)	:=(others=>'0');
-- VALID --
signal		valid_int			:	std_logic						:='0';
-- COUNTER --
signal		timer				:	integer	range 0 to 10  			:=0;

-- SRAM SIGNAL  --
signal		SRAM_din			:	unsigned(reg_32bit-1   downto 0)	:=(others=>'0');
signal		SRAM_dout			:	unsigned(reg_32bit-1   downto 0)	:=(others=>'0');
signal		SRAM_addr			:	unsigned(reg_6bit-1   downto 0)		:=(others=>'0');
signal		SRAM_wr				:	std_logic							:='0';


type state is (S0,S1,S2,S3,S4,S5);
signal 	current_state,next_state		:	state	;
 
 
 
begin

-- outputs to write into output text file
AC				<=	REG_AC;
B				<=	REG_B;
C				<=	REG_C;
D				<=	REG_D;
BUS_value		<=	REG_BUS;
valid			<=	valid_int;

		-- ALU DEFINITION --
REG_AC	<=	REG_C				when 	func="001"	else 
			REG_D				when	func="010"	else
			REG_C +   REG_D		when	func="011"	else
			REG_C AND REG_D		when	func="100"	else
			REG_C XOR REG_D		when	func="101"	else
			REG_C -   REG_D		when	func="110"	else
			(others=>'0');
-------------------------------------------
		--  BUS selection  --
REG_BUS	<=	REG_AC 		when SEL_BUS="01" else
			REG_B 		when SEL_BUS="10" else
			SRAM_dout 	when SEL_BUS="11" else
			(others=>'0');
-------------------------------------------
REG_A	<=	REG_BUS(reg_6bit-1 DOWNTO 0) WHEN LD_A='1' ELSE	(others=>'0');
REG_B	<=	REG_BUS						 WHEN LD_B='1' ELSE	(others=>'0');
REG_C	<=	REG_BUS						 WHEN LD_C='1' ELSE	(others=>'0');
REG_D	<=	REG_BUS						 WHEN LD_D='1' ELSE	(others=>'0');

process(clk)
begin 
if rising_edge(clk) then

	opcode_int		<=	opcode;
	current_state	<= 	next_state;	

	if (rst='1') then 
		current_state	<= 	S0;	
	end if;

end if;
end process;


process(opcode_int,current_state)
begin
--  INITIALIZATION  -- 
SEL_BUS		<=	"00";
LD_A		<=  '0';
LD_B		<=  '0';
LD_C		<=  '0';
LD_D		<=  '0';
LD_AC		<=  '0';
valid_int	<=	'0';

case (current_state) is 

	when S0	=> 
		
		case(opcode_int) is
			-- AC <- C
			when  "0001"	=> func<="001"; valid_int<='0'; next_state<=S1;
			-- AC <- D
			when  "0010"	=> func<="010"; valid_int<='0'; next_state<=S1;	
			-- AC <- C+D
			when  "0011"	=> func<="011"; valid_int<='0'; next_state<=S1;
			-- AC <- B AND C
			when  "0100"	=> LD_D<='1'; REG_D<=REG_B; valid_int<='0';next_state<=S1;	
			-- AC <- B XOR C
			when  "0101"	=> LD_D<='1'; REG_D<=REG_B; valid_int<='0';next_state<=S1;	
			-- AC <- MEM[A]
			when  "0110"	=> SRAM_addr<=REG_A; SEL_BUS<="11"; valid_int<='0'; next_state<=S1;
			-- MEM[A] <- AC 
			when  "0111"	=> REG_BUS<=REG_AC; SEL_BUS<="01"; valid_int<='0';next_state<=S1;
			-- AC <- MEM[B] + MEM[C]
			when  "1000"	=> LD_A<='1'; REG_A<=REG_C(5 DOWNTO 0);valid_int<='0'; next_state<=S1;
			-- AC <- MEM[B] - MEM[C]
			when  "1001"	=> LD_A<='1'; REG_A<=REG_C(5 DOWNTO 0);valid_int<='0'; next_state<=S1;
			-- MEM[A] <- B XOR C
			when  "1010"	=> REG_D<=REG_B; LD_D<='1';valid_int<='0'; next_state<=S1;
			-- MEM[A] <- B << C[4:0]
			when  "1011"	=> SRAM_din<=REG_B(26 downto 0) & REG_C(4 downto 0); valid_int<='1'; next_state<=S0;
			when  OTHERS	=> valid_int<='0'; next_state<=S0; 
		end case;
		
	when S1	=>										
		case(opcode_int) is
			-- AC <- C
			when  "0001"	=> LD_AC<='1'; valid_int<='1'; next_state<=S0;
			-- AC <- D
			when  "0010"	=> LD_AC<='1'; valid_int<='1'; next_state<=S0;	
			-- AC <- C+D
			when  "0011"	=> LD_AC<='1'; valid_int<='1'; next_state<=S0;		
			-- AC <- B AND C
			when  "0100"	=> func<="100"; valid_int<='0';next_state<=S2;	
			-- AC <- B XOR C
			when  "0101"	=> func<="101"; valid_int<='0';next_state<=S2;	
			-- AC <- MEM[A]
			when  "0110"	=> REG_C<=REG_BUS; LD_C<='1';valid_int<='0'; next_state<=S2;			
			-- MEM[A] <- AC 
			when  "0111"	=> SRAM_wr<='1'; SRAM_din<=REG_BUS; SRAM_addr<=REG_A; valid_int<='1'; next_state<=S0;			
			-- AC <- MEM[B] + MEM[C]
			when  "1000"	=> REG_C<=SRAM_dout; LD_C<='1'; valid_int<='0';next_state<=S2;
			-- AC <- MEM[B] - MEM[C]
			when  "1001"	=> REG_C<=SRAM_dout; LD_C<='1';valid_int<='0'; next_state<=S2;
			-- MEM[A] <- B XOR C
			when  "1010"	=> func<="101"; valid_int<='0';next_state<=S2;		
			when  OTHERS	=> valid_int<='0'; next_state<=S0; 
		end case;
		
	when S2	=>										
		case(opcode_int) is	
			-- AC <- B AND C
			when  "0100"	=> LD_AC<='1'; valid_int<='1';next_state<=S0;		
			-- AC <- B XOR C
			when  "0101"	=> LD_AC<='1'; valid_int<='1';next_state<=S0;			
			-- AC <- MEM[A]
			when  "0110"	=> func<="001"; valid_int<='0';next_state<=S3;
			-- AC <- MEM[B] + MEM[C]
			when  "1000"	=> REG_A<=REG_D(5 DOWNTO 0); LD_A<='1'; valid_int<='0';next_state<=S3;
			-- AC <- MEM[B] - MEM[C]
			when  "1001"	=> REG_A<=REG_D(5 DOWNTO 0); LD_A<='1';valid_int<='0'; next_state<=S3;
			-- MEM[A] <- B XOR C
			when  "1010"	=> LD_AC<='1'; valid_int<='1'; next_state<=S0;		
			when  OTHERS	=> valid_int<='0'; next_state<=S0; 
		end case;

	when S3	=>										
		case(opcode_int) is		
			-- AC <- MEM[A]
			when  "0110"	=> LD_AC<='1'; valid_int<='1'; next_state<=S0;
			-- AC <- MEM[B] + MEM[C]
			when  "1000"	=> REG_D<=SRAM_dout; LD_D<='1'; valid_int<='0';next_state<=S4;
			-- AC <- MEM[B] - MEM[C]
			when  "1001"	=> REG_D<=SRAM_dout; LD_D<='1'; valid_int<='0';next_state<=S4;
			when  OTHERS	=> valid_int<='0'; next_state<=S0; 
			end case;
		
	when S4	=>										
		
		case(opcode_int) is		
			-- AC <- MEM[B] + MEM[C]
			when  "1000"	=> func<="011";valid_int<='0'; next_state<=S5;
			-- AC <- MEM[B] - MEM[C]
			when  "1001"	=> func<="110";valid_int<='0'; next_state<=S5;
			when  OTHERS	=> valid_int<='0'; next_state<=S0; 
		end case;

	when S5	=>							

		case(opcode_int) is		
			-- AC <- MEM[B] + MEM[C]
			when  "1000"	=> LD_AC<='1'; valid_int<='1'; next_state<=S0;
			-- AC <- MEM[B] - MEM[C]
			when  "1001"	=> LD_AC<='1'; valid_int<='1'; next_state<=S0;
			when  OTHERS	=> valid_int<='0'; next_state<=S0; 
		end case;
		
	when  OTHERS	=> valid_int<='0'; next_state<=S0; 	
	
end case;	

end process;	

		---  instantiation  ---

SRAM_unit: entity work.SRAM 
port map(
din			=> SRAM_din,
addr		=> SRAM_addr,		
wr			=> SRAM_wr,	
dout		=> SRAM_dout
);

end behavioral;










