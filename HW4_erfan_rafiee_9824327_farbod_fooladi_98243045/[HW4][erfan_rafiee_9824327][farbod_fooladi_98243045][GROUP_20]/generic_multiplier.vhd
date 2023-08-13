library ieee;  
use ieee.std_logic_1164.all;  
---------------------------------------
----code by ERFAN & FARBOD ------------
---------------------------------------

entity generic_multiplier is
generic (COLUMN: integer := 4; ROW: integer := 4);
port ( A       :  in  std_logic_vector(COLUMN-1 downto 0);
       B       :  in  std_logic_vector(ROW-1 downto 0);
       answer  :  out std_logic_vector(ROW+COLUMN-1 downto 0) );
END entity generic_multiplier;

architecture behavioral of generic_multiplier is

component multiplier is
port (
    A    	 :  in std_logic;
    B    	 :  in std_logic;
    Prod_in  :  in std_logic;
    Cin  	 :  in std_logic;
    Prod_out :  out std_logic;
    Cout 	 :  out std_logic );
END component;


TYPE mult_memory is array (0 to ROW-1) of std_logic_vector(COLUMN-1 downto 0);
SIGNAL Cin  	: mult_memory;
SIGNAL Cout 	: mult_memory;
SIGNAL Prod_in  : mult_memory;
SIGNAL Prod_out : mult_memory;

Begin

    row_loop: for i in 0 to ROW-1 GENERATE
        column_loop: for j in 0 to COLUMN-1 GENERATE
            multiplier_instance : multiplier
            port map (
            A    	 => A(j),
            B    	 => B(i),
            Prod_in  => Prod_in(i)(j),
            Cin  	 => Cin(i)(j),
            Prod_out => Prod_out(i)(j),
            Cout 	 => Cout(i)(j) );
        END GENERATE;
    END GENERATE;

    carry_in_init: for j in 0 to COLUMN-1 GENERATE 
        Cin(0)(j) <= '0'; 
    END GENERATE;

    carry_in_row: for i in 1 to ROW-1 GENERATE
        carry_in_column: for j in 0 to COLUMN-2 GENERATE 
            Cin(i)(j) <= Prod_out(i-1)(j+1); 
        END GENERATE;
        Cin(i)(COLUMN-1) <= Cout(i-1)(COLUMN-1);
    END GENERATE;

    prod_in_row: for i in 0 to ROW-1 GENERATE 
        Prod_in(i)(0) <= '0'; 
        prod_in_column: for j in 1 to COLUMN-1 GENERATE 
            Prod_in(i)(j) <= Cout(i)(j-1); 
        END GENERATE;
    END GENERATE;

    answer_loop: for j in 0 to ROW-1 GENERATE
        answer(j) <= Prod_out(j)(0);
    END GENERATE;

    answer(ROW+COLUMN-2 downto ROW) <= Prod_out(ROW-1)(COLUMN-1 downto 1);
    answer(ROW+COLUMN-1) <= Cout(ROW-1)(COLUMN-1);

END behavioral;