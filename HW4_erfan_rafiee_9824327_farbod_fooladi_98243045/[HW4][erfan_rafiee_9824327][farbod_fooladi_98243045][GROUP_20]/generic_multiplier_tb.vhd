---------------------------------------------
------ Generic multiplier Testbench ---------
---------------------------------------------
---------------------------------------------
----code by ERFAN & FARBOD ------------------
---------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity generic_multiplier_tb is
end generic_multiplier_tb;

architecture test of generic_multiplier_tb is

    component generic_multiplier is
        generic (COLUMN : integer := 4 ; ROW : integer := 4);
        port(
            A    	 :  in  std_logic_vector(COLUMN-1 downto 0);
            B    	 :  in  std_logic_vector(ROW-1 downto 0);
            answer :  out std_logic_vector(COLUMN+ROW-1 downto 0) 
        );
    end component;

    SIGNAL 	A_tb  	 : std_logic_vector(3 DOWNTO 0) := "1101" ;
 SIGNAL 		B_tb  		 : std_logic_vector(3 DOWNTO 0) := "0110" ;
 SIGNAL 		answer_tb  : std_logic_vector(7 DOWNTO 0);

 BEGIN
    cut: generic_multiplier
    generic map (
        ROW => 4,
        COLUMN => 4 )
    port map (
        A    	=> A_tb,
        B    	=> B_tb,
        answer => answer_tb );
	A_tb <= "1001" AFTER 15ns , "1011" AFTER 30ns;
	B_tb <= "1100" AFTER 15ns , "0101" AFTER 30ns;
 
 
END test;