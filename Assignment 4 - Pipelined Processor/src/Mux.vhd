Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Mux is
    port ( 
		in1: in std_logic_vector (31 downto 0);
		in2: in std_logic_vector (31 downto 0);
		sel: in std_logic;
	   outp: out std_logic_vector (31 downto 0) 
		);
end entity Mux;

architecture behavioural of Mux is
	 
begin

   with sel select
	outp<=in1 when '0',
			in2 when '1',
			in1 when others;
	
end behavioural;