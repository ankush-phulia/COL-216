Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Data_Path is
Port(
	clk: in std_logic;
	rsrc: in std_logic;
	rw: in std_logic;
	asrc: in std_logic;
	Fset: in std_logic_vector(3 downto 0);
	actrl: in std_logic_vector(3 downto 0);
	tomult: in std_logic;
	MR: in std_logic;
	MW: in std_logic;
	MtR: in std_logic;
	psrc: in std_logic;
	shiften: in std_logic;
	flagctrl:out std_logic_vector(3 downto 0);
	outputinstruction:out std_logic_vector(31 downto 0)
	);
end Data_Path;

architecture behavioural of Data_Path is

component PC is
    port ( 
		inp: in std_logic_vector (31 downto 0);
		clk: in std_logic;
	   outp: out std_logic_vector (31 downto 0) 
		);
end component;

component Flags is
    port ( 
		inp: in std_logic_vector (3 downto 0);
		ctrl: in std_logic;
		enable: in std_logic_vector(3 downto 0);
	   outp: out std_logic_vector (3 downto 0) 
		);
end component;

component Instr_Mem is
    port ( 
		Addr: in  std_logic_vector (31 downto 0);
	   Instr: out std_logic_vector (31 downto 0) 
		);
end component;

component Shifter is
Port(
	input: in std_logic_vector(31 downto 0);
	operation: in std_logic_vector(1 downto 0);
	shift_amt: in std_logic_vector(4 downto 0);
	outp: out std_logic_vector(31 downto 0);
	en:in std_logic
	);
end component;

component Extender is
    port ( 
		indata : in std_logic_vector (11 downto 0);
	   outdata: out std_logic_vector (31 downto 0) 
		);
end component;

component Sign_Extender is
    port ( 
		indata : in std_logic_vector (23 downto 0);
	   outdata: out std_logic_vector (31 downto 0) 
		);
end component;

component Mux4 is
    port ( 
		in1: in std_logic_vector (3 downto 0);
		in2: in std_logic_vector (3 downto 0);
		sel: in std_logic;
	   outp: out std_logic_vector (3 downto 0) 
		);
end component;

component Register_File is
Port(
	inr: in std_logic_vector(31 downto 0);
	inadd: in std_logic_vector(3 downto 0);
	outadd1: in std_logic_vector(3 downto 0);
	outadd2: in std_logic_vector(3 downto 0);
	en: in std_logic;
	outr1: out std_logic_vector(31 downto 0);
	outr2: out std_logic_vector(31 downto 0);
	clk: in std_logic
	);
end component;

component Mux is
    port ( 
		in1: in std_logic_vector (31 downto 0);
		in2: in std_logic_vector (31 downto 0);
		sel: in std_logic;
	   outp: out std_logic_vector (31 downto 0) 
		);
end component;

component ALU is
Port(
	a: in std_logic_vector(31 downto 0);
	b: in std_logic_vector(31 downto 0);
	flag: out std_logic_vector(3 downto 0);
	cin: in std_logic;
	mul: in std_logic;
	operation: in std_logic_vector(3 downto 0);
	s: inout std_logic_vector(31 downto 0)
	);
end component;

component Data_Mem is
    port ( 
		Addr: in  std_logic_vector (31 downto 0);
		en: in std_logic;
		en2: in std_logic;
		indata : in std_logic_vector (31 downto 0);
	   outdata: out std_logic_vector (31 downto 0);
		clk: in std_logic
		);
end component;

component Adder is
Port(
	a: in std_logic_vector(31 downto 0);
	b: in std_logic_vector(31 downto 0);
	s: out std_logic_vector(31 downto 0)
	);
end component;

signal address: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal instruction: std_logic_vector(31 downto 0);
signal rad: std_logic_vector(3 downto 0):=instruction(3 downto 0);
signal rad1: std_logic_vector(3 downto 0):=instruction(19 downto 16);
signal rad2: std_logic_vector(3 downto 0);
signal wad: std_logic_vector(3 downto 0):=instruction(15 downto 12);
signal wd: std_logic_vector(31 downto 0);
signal rd1: std_logic_vector(31 downto 0);
signal rd2: std_logic_vector(31 downto 0);
signal extended: std_logic_vector(31 downto 0);
signal alu2: std_logic_vector(31 downto 0);
signal flgsin: std_logic_vector(3 downto 0):="0000";
signal flgsout: std_logic_vector(3 downto 0):="0000";
signal in_carry:std_logic := flgsout(1);
signal result: std_logic_vector(31 downto 0);
signal out_data: std_logic_vector(31 downto 0);
signal imm: std_logic_vector(11 downto 0):=instruction(11 downto 0);
signal res4: std_logic_vector(31 downto 0);
signal imm2: std_logic_vector(23 downto 0):=instruction(23 downto 0);
signal immout: std_logic_vector(31 downto 0):="00000000000000000000000000000010";
signal res8: std_logic_vector(31 downto 0);
signal resoff8: std_logic_vector(31 downto 0):="00000000000000000000000000001000";
signal pcnext: std_logic_vector(31 downto 0):="00000000000000000000000000000001";
signal Ibit: std_logic:=instruction(25);
signal immediate: std_logic_vector(7 downto 0):=instruction(7 downto 0);
signal rot: std_logic_vector(4 downto 0);
signal stype: std_logic_vector(1 downto 0):=instruction(6 downto 5);
signal samt: std_logic_vector(4 downto 0):=instruction(11 downto 7);
signal shifted: std_logic_vector(31 downto 0);
signal shifted2: std_logic_vector(31 downto 0);
signal finshift: std_logic_vector(31 downto 0);

begin

outputinstruction<=instruction;
flagctrl<=flgsout;
rot<=instruction(11 downto 8)&'0';

Prog_Counter: PC port map (pcnext,clk,address);
Instruction_Memory: Instr_Mem port map (address,instruction);
M1: Mux4 port map (instruction(3 downto 0),instruction(15 downto 12),rsrc,rad2);
Registers: Register_File port map (wd,instruction(15 downto 12),instruction(19 downto 16),rad2,rw,rd1,rd2,clk);
EX: Extender port map(instruction(11 downto 0),extended);
M2: Mux port map(rd2,extended,asrc,alu2);
ShifterX: Shifter port map (alu2,instruction(6 downto 5),instruction(11 downto 7),shifted,shiften);
ShifterY: Shifter port map (alu2,"00",rot,shifted2,shiften);
M25:Mux port map (shifted,shifted2,instruction(25),finshift);
ALUX: ALU port map(rd1,finshift,flgsin,flgsout(2),tomult,actrl,result);
FSS: Flags port map (flgsin,clk,Fset,flgsout);
Data_Memory:Data_Mem port map (result,MR,MW,rd2,out_data,clk);
M3: Mux port map (result,out_data,MtR,wd);
Add4: Adder port map (address,"00000000000000000000000000000001",res4);
S2: Sign_Extender port map (instruction(23 downto 0),immout);
Addoff: Adder port map (res4,immout,res8);
Addoff2: Adder port map (res8,"00000000000000000000000000000001",resoff8);
M4: Mux port map(res4,resoff8,psrc,pcnext);

end behavioural;