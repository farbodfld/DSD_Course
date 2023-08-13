library ieee;  
use ieee.std_logic_1164.all;
---------------------------------------
--multiplier entity -------------------
--------------------------------------- 
---------------------------------------
----code by ERFAN & FARBOD ------------
---------------------------------------


entity multiplier is  
port (  A		:  in std_logic;  
		B     	:  in std_logic;  
		Prod_in  :  in std_logic;    -- prodcut in  
		Cin   	:  in std_logic;    -- carry in
		Cout  	:  out std_logic; 	-- carry out
		Prod_out:  out std_logic);   --product out
end multiplier;  

architecture concurrent of multiplier is
begin  
    Prod_out <= (A and B) xor Cin xor Prod_in;
    Cout <= (Cin and Prod_in) or (A and B and Cin) or (A and B and Prod_in);
end concurrent;