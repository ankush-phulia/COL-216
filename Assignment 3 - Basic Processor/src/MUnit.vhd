Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity MUnit is
Port(
	a: in std_logic_vector(31 downto 0);
	b: in std_logic;
	level: in std_logic_vector(4 downto 0);
	sin: in std_logic_vector(31 downto 0);
	sout: out std_logic_vector(31 downto 0)
	);
end MUnit;

architecture behavioural of MUnit is

component Shifter is
Port(
	input: in std_logic_vector(31 downto 0);
	operation: in std_logic_vector(1 downto 0);
	shift_amt: in std_logic_vector(4 downto 0);
	outp: out std_logic_vector(31 downto 0);
	en: in std_logic
	);
end component;

component Adder is
Port(
	a: in std_logic_vector(31 downto 0);
	b: in std_logic_vector(31 downto 0);
	s: out std_logic_vector(31 downto 0)
	);
end component;

component Andder is
Port(
	a: in std_logic_vector(31 downto 0);
	b: in std_logic_vector(31 downto 0);
	c: in std_logic;
	outp: out std_logic_vector(31 downto 0)
	);
end component;

signal prod: std_logic_vector(31 downto 0);
signal outp: std_logic_vector(31 downto 0);

begin

	ShifterX : Shifter port map (a,"00",level,prod,'1');
	AdderX: Adder port map (prod,sin,outp);
	AndderX: Andder port map (outp,sin,b,sout);
	
end behavioural;