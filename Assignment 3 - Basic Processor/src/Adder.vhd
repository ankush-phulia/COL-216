library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Adder is
Port(
	a: in std_logic_vector(31 downto 0);
	b: in std_logic_vector(31 downto 0);
	s: out std_logic_vector(31 downto 0)
	);
end Adder;

architecture behavioural of Adder is

component AddUnit is
Port(
	a: in std_logic;
	b: in std_logic;
	cin: in std_logic;
	cout: out std_logic;
	sum: out std_logic
	);
end component;
signal carry: std_logic_vector(32 downto 0);

begin

	carry(0)<='0';
	
	GEN_REG: 
   for I in 0 to 31 generate
      AddUnitX : AddUnit port map (a(I),b(I),carry(I),carry(I+1),s(I));
   end generate GEN_REG;

end behavioural;