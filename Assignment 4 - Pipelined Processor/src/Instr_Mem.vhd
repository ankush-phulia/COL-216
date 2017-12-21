Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Instr_Mem is
    port (
		Addr: in  std_logic_vector (31 downto 0);
	   Instr: out std_logic_vector (31 downto 0)
		);
end entity Instr_Mem;

architecture behavioural of Instr_Mem is

   type MemArr is array (0 to 1023) of std_logic_vector (31 downto 0);
	signal Memory2: MemArr:=(others => "00000000000000000000000000000000");

begin

Memory2(0) <= x"E3A00002"; --mov r0,#2
Memory2(1) <= x"E3A01003"; --mov r1,#3
Memory2(2) <= x"E0012090"; --mul r2,r0,r1
Memory2(3) <= x"E3A00002";
Memory2(4) <= x"E5801002";	--str r1,[r0,#2]
Memory2(5) <= x"E5907002";	--ldr r7,[r0,#2]
Memory2(6) <= x"E1570001";	--cmp r7,r1
Memory2(7) <= x"00878001";	--addeq r8,r7,r1q
Memory2(8) <= x"E1510000";	--cmp r1,r0
Memory2(9) <= x"00819000";	--addeq r9,r1,r0
Memory2(10)  <=x"1A000008"; --bne addr(20)
Memory2(11) <= x"1041A000";--subne r10,r1,r0
Memory2(20) <=x"E3A0B007"; --mov r11,#7

   process(Addr)
	begin
		Instr <= Memory2(conv_integer(Addr) mod 1024);	
	end process;	 
end behavioural;
