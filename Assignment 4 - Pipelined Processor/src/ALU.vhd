Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity ALU is
Port(
	a: in std_logic_vector(31 downto 0);
	b: in std_logic_vector(31 downto 0);
	flag: out std_logic_vector(3 downto 0);
	cin: in std_logic;
	mul: in std_logic;
	operation: in std_logic_vector(3 downto 0);
	s: inout std_logic_vector(31 downto 0)
	);
end ALU;

architecture behavioural of ALU is

component ALUnit is
Port(
	a: in std_logic;
	b: in std_logic;
	operation: in std_logic_vector(1 downto 0);
	cin: in std_logic;
	inp_ctrl: in std_logic_vector(0 downto 0);
	cout: out std_logic;
	s: out std_logic
	);
end component;

component Multiplier is
Port(
	a: in std_logic_vector(31 downto 0);
	b: in std_logic_vector(31 downto 0);
	outp: out std_logic_vector(31 downto 0)
	);
end component;

component Choose is
Port(
	a: in std_logic_vector(31 downto 0);
	b: in std_logic_vector(31 downto 0);
	c: in std_logic;
	outp: out std_logic_vector(31 downto 0)
	);
end component ;

signal carry:std_logic_vector(32 downto 0);
signal inp_ctrl:std_logic_vector(0 downto 0);
signal oper:std_logic_vector(1 downto 0);
signal a1:std_logic_vector(31 downto 0);
signal b1:std_logic_vector(31 downto 0);
signal ss:std_logic_vector(31 downto 0);
signal c2:std_logic_vector(31 downto 0);

begin

	GEN_REG: 
   for I in 0 to 31 generate
      ALUnitX : ALUnit port map (a1(I),b1(I),oper,carry(I),inp_ctrl,carry(I+1),ss(I));
   end generate GEN_REG;
	
	MultiplierX: Multiplier port map (a,b,c2);
	
	Chooser: Choose Port map (ss,c2,mul,s);

	process(operation,a,b,mul,cin)
	begin
		case(operation) is
			when "0000" => --ADD
				a1<=a;
				b1<=b;
				carry(0)<='0';
				oper<="11";
				inp_ctrl<="1";
				
			when "0001" => --SUB
				a1<=a;
				b1<=b;
				carry(0)<='1';
				oper<="11";
				inp_ctrl<="0";

			when "0010" => --RSB
				a1<=b;
				b1<=a;
				carry(0)<='1';
				oper<="11";
				inp_ctrl<="0";

			when "0011" => --ADC
				a1<=a;
				b1<=b;
				carry(0)<=cin;
				oper<="11";
				inp_ctrl<="1";
				
			when "0100" => --SBC
				a1<=b;
				b1<=a;
				carry(0)<=cin;
				oper<="11";
				inp_ctrl<="0";
				
			when "0101" => --RSC
				a1<=b;
				b1<=a;
				carry(0)<=cin;
				oper<="11";
				inp_ctrl<="0";

			when "0110" => --AND
				a1<=a;
				b1<=b;
				carry(0)<='0';
				oper<="00";
				inp_ctrl<="1";
			
			when "0111" => --ORR
				a1<=a;
				b1<=b;
				carry(0)<='0';
				oper<="01";
				inp_ctrl<="1";
				
			when "1000" => --EOR	
				a1<=a;
				b1<=b;
				carry(0)<='0';
				oper<="10";
				inp_ctrl<="1";
				
			when "1001" => --BIC
				a1<=a;
				b1<=b;
				carry(0)<='0';
				oper<="00";
				inp_ctrl<="0";
				
			when "1010" => --CMP
				a1<=a;
				b1<=b;
				carry(0)<='1';
				oper<="11";
				inp_ctrl<="0";
				
			when "1011" => --CMN
				a1<=b;
				b1<=a;
				carry(0)<='0';
				oper<="11";
				inp_ctrl<="1";
				
			when "1100" => --TEQ
				a1<=a;
				b1<=b;
				carry(0)<='0';
				oper<="10";
				inp_ctrl<="1";

			when "1101" => --TST
				a1<=a;
				b1<=b;
				carry(0)<='0';
				oper<="00";
				inp_ctrl<="1";

			when "1110" => --MOV
				a1<="00000000000000000000000000000000";
				b1<=b;
				carry(0)<='0';
				oper<="11";
				inp_ctrl<="1";				
				
			when others => --MVN
				a1<="00000000000000000000000000000000";
				b1<=b;
				carry(0)<='0';
				oper<="11";
				inp_ctrl<="0";				
				
		end case;
	end process;
	
	flag(3)<=(carry(31) xor carry(32)); --V
	flag(2)<='1' when ss="00000000000000000000000000000000" else '0'	;	--Z
	flag(1)<=carry(32); 		--C
	flag(0)<=ss(31);  		--N
	
end behavioural;	







