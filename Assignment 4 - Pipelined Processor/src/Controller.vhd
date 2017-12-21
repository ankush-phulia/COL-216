Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Controller is
    port ( 
		instruction: in std_logic_vector(31 downto 0);
		flagctrl: in std_logic_vector(3 downto 0);
		rsrc:out std_LOGIC;
		rw:out std_LOGIC;
		asrc:out std_LOGIC;
		MW:out std_LOGIC;
		MR:out std_LOGIC;
		MtR:out std_LOGIC;
		psrc:out std_LOGIC;
		Fset:out std_logic_vector(3 downto 0);
		shiften: out std_LOGIC;
		tomult: out std_LOGIC;
		opcod: out std_logic_vector(3 downto 0)
		);
end entity Controller;

architecture behavioural of Controller is

component Actrl is
    port ( 
		instr: in std_logic_vector(5 downto 0);
		opcode: out std_logic_vector(3 downto 0)
		);
end component;

component Bctrl is
    port ( 
		instrb: in std_logic_vector(3 downto 0); 
		flag: in std_logic_vector(3 downto 0);
		p: out std_logic
		);
end component;
	
signal instra: std_logic_vector(5 downto 0):=instruction(26 downto 21);
signal instrb: std_logic_vector(3 downto 0):=instruction(31 downto 28);
signal p: std_logic;
	
begin

instrb<=instruction(31 downto 28);
instra<=instruction(26 downto 21);

Actrlx: Actrl port map (instra,opcod);
Bctrlx: Bctrl port map (instrb,flagctrl,p);

process(p, instruction)
begin
	tomult<='0';
	shiften<='0';
	if(instruction(27) = '0' and instruction(26) = '0') then --DP
		rsrc <= '0';
		asrc <= instruction(25);
		MW <= '0';
		MR <= '0';
		psrc <= '0';
		MtR <= '0';		
		if (instruction(25 downto 22)="0000" and instruction(7 downto 4)="1001" and instruction(20) = '0') then --mul
			tomult<='1';
			rw <= p;
			Fset <= "0000";
		elsif (instruction(25 downto 22)="0000" and instruction(7 downto 4)="1001" and instruction(20) = '1') then --mul
			tomult<='1';
			rw <= p;
			Fset <= p&p&p&p;
		elsif(instruction(24) = '0' and instruction(20) = '0') then
			rw <= p;
			shiften<='1';
			Fset <= "0000";
		elsif(instruction(24) = '0' and instruction(20) = '1') then
		   rw <= p;
			shiften<='1';
			Fset <= p&p&p&p;
		elsif(instruction(23) = '1' and instruction(20) = '0') then
		   rw <= p;
			shiften<='1';
			Fset <= "0000";
		elsif(instruction(23) = '1' and instruction(20) = '1') then
		   rw <= p;
			shiften<='1';
			Fset <= p&p&p&p;
		elsif(instruction(24) = '1' and instruction(23) = '0') then --cmp/tst
		   rw <= '0';
			shiften<='1';
			Fset <= "1111";
		end if;
	elsif(instruction(27) = '0' and instruction(26) = '1') then --DT
		rsrc <= '1';
		asrc <= '1';
		Fset <= "0000";
		psrc <= '0';
		MtR <= '1';
		if(instruction(20) = '0') then --Str
			rw <= '0';
			MW <= p;
			MR <= '0';
		elsif(instruction(20) = '1') then --Ldr
			rw <= p;
			MW <= '0';
			MR <= '1';
		end if;
	elsif(instruction(27) = '1' and instruction(26) = '0') then --B
		rsrc <= '0';
		asrc <= '0';
		Fset <= "0000";
		psrc <= p;
		MtR <= '0';
		rw <= '0';
		MW <= '0';
		MR <= '0';
	end if;
end process;

end behavioural;