library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


entity Register_File is
Port(
	inr: in std_logic_vector(31 downto 0);
	inadd: in std_logic_vector(3 downto 0);
	outadd1: in std_logic_vector(3 downto 0);
	outadd2: in std_logic_vector(3 downto 0);
	en: in std_logic;
	outr1: out std_logic_vector(31 downto 0);
	outr2: out std_logic_vector(31 downto 0);
	clk: in std_logic
	);
end Register_File;

architecture behavioural of Register_File is

type registerSet is array(0 to 15) of std_logic_vector(31 downto 0);
signal Resgisters : registerSet:=(others=>x"00000000");

begin

	process(en,outadd1,outadd2,inadd,inr,clk)
	begin 
		if (en = '1' and falling_edge(clk)) then
			if (inadd = outadd1) then
				Resgisters(conv_integer(inadd)mod 16) <= inr;
				outr2 <= Resgisters(conv_integer(outadd2) mod 16);
			elsif (inadd = outadd2) then
				Resgisters(conv_integer(inadd)mod 16) <= inr;
				outr1 <= Resgisters(conv_integer(outadd1)mod 16);
			else
				Resgisters(conv_integer(inadd)mod 16) <= inr;
				outr1 <= Resgisters(conv_integer(outadd1)mod 16);
				outr2 <= Resgisters(conv_integer(outadd2)mod 16);
			end if;
		else
			outr1 <= Resgisters(conv_integer(outadd1)mod 16);
			outr2 <= Resgisters(conv_integer(outadd2)mod 16);
		end if;
	
	end process;

	
end behavioural;