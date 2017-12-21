Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity ALUnit is
Port(
	a: in std_logic;
	b: in std_logic;
	operation: in std_logic_vector(1 downto 0);
	cin: in std_logic;
	inp_ctrl: in std_logic_vector(0 downto 0);
	cout: out std_logic;
	s: out std_logic
	);
end ALUnit;

architecture behavioural of ALUnit is

begin
	process(a,b,cin,operation,inp_ctrl)
	
	begin 
		case(operation) is
			when "00" => 
				if inp_ctrl="0" then 
					s<= a and (not b);
				else  s<= a and b ;
				end if;
				
			when "01" => 
				if inp_ctrl="0" then 
					s<= a or (not b);
				else  s<= a or b ;
				end if;
				
			when "10" => 
				if inp_ctrl="0" then 
					s<= a xor (not b);
				else  s<= a xor b ;
				end if;
				
			when others => 
				if inp_ctrl="0" then 
					s<= a xor (not b) xor cin;
					cout<=(a and not b) or (a and cin) or (not b and cin);
				else  
					s<= a xor b xor cin ;
					cout<=(a and b) or (a and cin) or (b and cin);
				end if;
		end case;
		
	
	end process;
end behavioural;