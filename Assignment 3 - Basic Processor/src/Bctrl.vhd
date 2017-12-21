Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Bctrl is
    port ( 
		instrb: in std_logic_vector(3 downto 0); 
		flag: in std_logic_vector(3 downto 0); --VZCN
		p: out std_logic
		);
end entity Bctrl;

architecture behavioural of Bctrl is
		
begin
	process(flag,instrb)
	begin
	
		case instrb is
			when "0000" => p <= flag(2);
			when "0001" => p <= not flag(2);
			when "0010" => p <= flag(1);
			when "0011" => p <= not flag(1);
			when "0100" => p <= flag(0);
			when "0101" => p <= not flag(0);
			when "0110" => p <= flag(3);
			when "0111" => p <= not flag(3);
			when "1000" => p <= (not (flag(2))) and flag(1);
			when "1001" => p <= not ( (not (flag(2))) and flag(1));
			when "1010" => p <= flag(3) xnor flag(0);
			when "1011" => p <= (flag(3) xor flag(0));
			when "1100" => p <= (flag(3) xnor flag(0)) and (not flag(2));
			when "1101" => p <= not ((flag(3) xnor flag(0)) and (not flag(2)));
			when "1110" => p <= '1';
			when others => null;
			
		end case;
		
		end process;

end behavioural;