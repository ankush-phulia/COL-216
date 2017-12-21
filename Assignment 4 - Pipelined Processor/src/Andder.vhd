library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Andder is
Port(
	a: in std_logic_vector(31 downto 0);
	b: in std_logic_vector(31 downto 0);
	c: in std_logic;
	outp: out std_logic_vector(31 downto 0)
	);
end Andder;

architecture behavioural of Andder is

begin

	process(a,b,c)
	begin	
		if (c='1') then
			outp<=a;
		else 
			outp<=b;
	end if;
	
	end process;
end behavioural;