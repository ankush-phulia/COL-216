Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity PC is
    port ( 
		inp: in std_logic_vector (31 downto 0);
		clk: in std_logic;
	   outp: out std_logic_vector (31 downto 0) 
		);
end entity PC;

architecture behavioural of PC is
	
	signal PRegister:std_logic_vector(31 downto 0):="00000000000000000000000000000000";
	
begin

process(clk)
	begin	
		if rising_edge(clk) then
			PRegister<=inp;
		end if;
			outp<=PRegister;
		
	end process;
end behavioural;