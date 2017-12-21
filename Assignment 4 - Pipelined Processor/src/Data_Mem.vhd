Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Data_Mem is
    port ( 
		Addr: in  std_logic_vector (31 downto 0);
		en: in std_logic;
		en2: in std_logic;
		indata : in std_logic_vector (31 downto 0);
	   outdata: out std_logic_vector (31 downto 0);
		clk: in std_logic
		);
end entity Data_Mem;

architecture behavioural of Data_Mem is

    type MemArr is array (0 to 1023) of std_logic_vector (31 downto 0);
	 signal Memory1: MemArr:=(others=>x"00000000");
	 
begin

   process(addr,en,en2,indata,clk)
	begin	
		if (en='1') then
			outdata <= Memory1(conv_integer(Addr) mod 1024);
		else 
			null;
		end if;
		
		if (en2='1' and falling_edge(clk)) then
			Memory1(conv_integer(Addr) mod 1024) <= indata;
		else 
			null;
		end if;
		
	end process;
	
end behavioural;