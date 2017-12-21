Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Sign_Extender is
    port ( 
		indata : in std_logic_vector (23 downto 0);
	   outdata: out std_logic_vector (31 downto 0) 
		);
end entity Sign_Extender;

architecture behavioural of Sign_Extender is

begin

   process(indata)
	begin
		outdata(23 downto 0)<=indata;
		if (indata(23)='1') then
			outdata(31 downto 24)<="11111111";
		else
			outdata(31 downto 24)<="00000000";
		end if;
		
	end process;	 
end behavioural;