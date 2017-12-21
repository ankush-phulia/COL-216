library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity AddUnit is
Port(
	a: in std_logic;
	b: in std_logic;
	cin: in std_logic;
	cout: out std_logic;
	sum: out std_logic
	);
end AddUnit;

architecture behavioural of AddUnit is

begin

	process(a,b,cin)
	begin	
		sum<=a xor b xor cin;
		cout<= (a and b) or (a and cin) or (b and cin);
	
	end process;
end behavioural;