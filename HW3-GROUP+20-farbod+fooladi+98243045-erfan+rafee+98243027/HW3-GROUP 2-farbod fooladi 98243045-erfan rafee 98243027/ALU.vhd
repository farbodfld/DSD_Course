library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
--------------------------------
--------- ALU 32-bit -----------
--------------------------------
----------  WRITTEN BY  --------
--------- FARBOD FOOLADI ------- 
---------		& 			 -------
--------- ERFAN RAFEE ----------
entity ALU_32 is
  generic ( 
     constant N: natural := 1  -- number of shited or rotated bits
    );
  
    Port (
    A, B : in STD_LOGIC_VECTOR(31 downto 0); -- 2 inputs 32-bit
    ALU_Sel : in STD_LOGIC_VECTOR(3 downto 0); -- 1 input 4-bit for selecting function
	 Cin		: in STD_LOGIC;		-- CarryIn flag
    ALU_Out : out STD_LOGIC_VECTOR(31 downto 0); -- 1 output 32-bit
    Carryout : out std_logic -- Carryout flag
    );
end ALU_32; 
architecture Behavioral of ALU_32 is

signal ALU_Result : std_logic_vector (31 downto 0);
signal tmp: std_logic_vector (32 downto 0);
shared variable h : integer range 0 to 32;

begin
   process(A,B,ALU_Sel)
 begin
  case(ALU_Sel) is
  when "0000" => -- NOT A
   ALU_Result <= not A after 1ns; 

  when "0001" => -- NAND
   ALU_Result <= A nand B after 2ns;

  when "0010" => -- NOR
   ALU_Result <= A nor B after 2ns;

  when "0011" => -- XOR
   ALU_Result <= A xor B after 2ns;

  when "0100" => -- AND
   ALU_Result <= A and B after 1ns;

  when "0101" => -- HW(A)
    h := 0;
  for i in A'range loop
    if A(i) = '1' then
      h := h + 1;
    end if;
  end loop;
   ALU_Result <= std_logic_vector(to_unsigned(h, 32)) after 6ns;

  when "0110" => -- HW(B)
    h := 0;
  for i in B'range loop
    if B(i) = '1' then
      h := h + 1;
    end if;
  end loop;
   ALU_Result <= std_logic_vector(to_unsigned(h, 32)) after 6ns;

  when "0111" => -- -A
   ALU_Result <= (not A) + 1 after 3ns;

  when "1000" => -- additional 
   ALU_Result <= A + B + Cin after 3ns;

  when "1001" => -- subtraction
   ALU_Result <= A - B after 3ns;
	
  when "1010" => -- Greater comparison
   if(A>B) then
    ALU_Result <= (0 => '1', others => '0') after 2ns;
   else
    ALU_Result <= (others => '0') after 2ns;
   end if; 

   when "1011" =>  --
    if(A<B) then
        ALU_Result <= (0 => '1', others => '0') after 2ns;
    else
        ALU_Result <= (others => '0') after 2ns;
    end if;

  when "1100" => -- Equal comparison   
   if(A=B) then
    ALU_Result <= (0 => '1', others => '0') after 2ns;
   else
    ALU_Result <= (others => '0') after 2ns;
   end if;

   when "1101" => -- ROR
    ALU_Result <= std_logic_vector(unsigned(A) ror N) after 1ns;

   when "1110" => -- ROL
    ALU_Result <= std_logic_vector(unsigned(B) rol N) after 1ns;

   when "1111" => -- Y=0
    ALU_Result <= (others => '0') after 1ns;

  when others => ALU_Result <= A + B ; 
  end case;
 end process;
 ALU_Out <= ALU_Result; -- ALU out
 tmp <= ('0' & A) + ('0' & B);
 Carryout <= tmp(32); -- Carryout flag
end Behavioral;