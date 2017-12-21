Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Multiplier is
Port(
	a: in std_logic_vector(31 downto 0);
	b: in std_logic_vector(31 downto 0);
	outp: out std_logic_vector(31 downto 0)
	);
end Multiplier;

architecture behavioural of Multiplier is

component MUnit is
Port(
	a: in std_logic_vector(31 downto 0);
	b: in std_logic;
	level: in std_logic_vector(4 downto 0);
	sin: in std_logic_vector(31 downto 0);
	sout: out std_logic_vector(31 downto 0)
	);
end component;

type Partials is array(32 downto 0) of std_logic_vector(31 downto 0);
signal PartialSums : Partials;

begin

	PartialSums(0)<="00000000000000000000000000000000";
	GEN_REG: 
   for I in 0 to 31 generate
      MUnitX : MUnit port map (a,b(I),std_logic_vector(to_unsigned(I,5)),PartialSums(I),PartialSums(I+1));
   end generate GEN_REG;	
	
	outp<=PartialSums(32);
	
end behavioural;