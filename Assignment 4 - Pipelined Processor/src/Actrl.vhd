Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Actrl is
    port ( 
		instr: in std_logic_vector(5 downto 0);
		opcode: out std_logic_vector(3 downto 0)
		);
end entity Actrl;

architecture behavioural of Actrl is

begin

	process(instr)
	begin
	if instr(5)='1' then --DT (LDR/STR)
		case(instr(2)) is
		when '1'=>
			opcode<="0000"; --UP
		when others=>
			opcode<="0001"; --Down
		end case;
	else
		case(instr(3 downto 0)) is
			when "0100" => --ADD
				opcode<="0000";
			
			when "0010" => --SUB
				opcode<="0001";
				
			when "0011" => --RSB
				opcode<="0010";

			when "0101" => --ADC
				opcode<="0011";
				
			when "0110" => --SBC
				opcode<="0100";
				
			when "0111" => --RSC
				opcode<="0101";
				
			when "0000" => --AND
				opcode<="0110";
			
			when "1100" => --ORR
				opcode<="0111";
				
			when "0001" => --EOR	
				opcode<="1000";
				
			when "1110" => --BIC
				opcode<="1001";
				
			when "1010" => --CMP
				opcode<="1010";
				
			when "1011" => --CMN
				opcode<="1011";
								
			when "1001" => --TEQ
				opcode<="1100";

			when "1000" => --TST
				opcode<="1101";
			
			when "1101"=> --MOV
				opcode<="1110";
				
			when others=> --MVN
				opcode<="1111";
		end case;
	end if;			

	end process;
end behavioural;