Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity RISC_Processor is
Port(
	clk: in std_logic
	);
end RISC_Processor;

architecture behavioural of RISC_Processor is

component Data_Path is
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
end component;

component Controller is
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
end component;

signal 	rsrc:std_logic;
signal	rw:std_logic:='0';
signal	asrc:std_logic;
signal	Fset:std_logic_vector(3 downto 0);
signal	actrl:std_logic_vector(3 downto 0);
signal	tomult:std_logic;
signal	MR:std_logic;
signal	MW:std_logic;
signal	MtR:std_logic;
signal	psrc:std_logic;
signal	shiften:std_logic;
signal	flagctrl:std_logic_vector(3 downto 0):="0000";
signal	outputinstruction:std_logic_vector(31 downto 0);

begin

DataPathX: Data_Path port map (clk,rsrc,rw,asrc,Fset,actrl,tomult,MR,MW,MtR,psrc,shiften,flagctrl,outputinstruction);
ControllerX: Controller port map (outputinstruction,flagctrl,rsrc,rw,asrc,MW,MR,MtR,psrc,Fset,shiften,tomult,actrl);

end behavioural;