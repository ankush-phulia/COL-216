Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Flags is
    port ( 
		inp: in std_logic_vector (3 downto 0);
		ctrl: in std_logic;
		enable: in std_logic_vector(3 downto 0);
	   outp: out std_logic_vector (3 downto 0) 
		);
end entity Flags;

architecture behavioural of Flags is
	
	signal FRegister:std_logic_vector(3 downto 0):="0000";
	
begin
	
   process(ctrl,inp,enable)
	begin
		if ctrl='1' then
			if enable(0)='1' then 
				FRegister(0)<=inp(0);
			end if;
			if enable(1)='1' then 
				FRegister(1)<=inp(1);
			end if;
			if enable(2)='1' then 
				FRegister(2)<=inp(2);
			end if;
			if enable(3)='1' then 
				FRegister(3)<=inp(3);
			end if;				
		outp<=FRegister;
		end if;
		
	end process;
	
end behavioural;