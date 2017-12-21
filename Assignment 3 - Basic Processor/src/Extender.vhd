Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Extender is
    port ( 
		indata : in std_logic_vector (11 downto 0);
	   outdata: out std_logic_vector (31 downto 0) 
		);
end entity Extender;

architecture behavioural of Extender is

begin

   process(indata)
	begin
		outdata(11 downto 0)<=indata;
		outdata(31 downto 12)<="00000000000000000000";
		
	end process;	 
end behavioural;