Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Shifter is
Port(
	input: in std_logic_vector(31 downto 0);
	operation: in std_logic_vector(1 downto 0);
	shift_amt: in std_logic_vector(4 downto 0);
	outp: out std_logic_vector(31 downto 0);
	en:in std_logic
	);
end Shifter;

architecture behavioural of Shifter is


begin
	process(input,shift_amt,operation,en)
	begin
		if en='1' then
		case(operation) is
			when "00"=> --LSL
				outp<=std_logic_vector(unsigned(input) sll to_integer(unsigned(shift_amt)));
			
			when "01"=> --RSL
				outp<=std_logic_vector(unsigned(input) srl to_integer(unsigned(shift_amt)));
			
			when "10"=> --ASR
				outp<=to_stdlogicvector(to_bitvector(input) sra to_integer(unsigned(shift_amt)));
			
			when others=> --ROR
				outp<=std_logic_vector(unsigned(input) ror to_integer(unsigned(shift_amt)));
			
		end case;	
		else
			outp<=input;
		end if;
	
	end process;
end behavioural;