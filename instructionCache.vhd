library IEEE,std;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity instructionCache is
	generic (addressableSpace : integer:= 16 ; wordSize: integer:= 16);
	port(interrupt,clk: in std_logic;
		instructionAddress: in std_logic_vector(addressableSpace - 1 downto 0);
		instruction: out std_logic_vector((wordSize*2)-1 downto 0);
		ISR : out std_logic_vector(addressableSpace - 1 downto 0);
		firstLocation : out std_logic_vector(addressableSpace - 1 downto 0));
		--initialMemory
end entity;

ARCHITECTURE implementInstructionCache OF instructionCache IS
--signal iAddress : integer;
type ram_type is Array(0 to 1023) of std_logic_vector(15 downto 0) ;
constant ISRLocation: std_logic_vector(15 downto 0):=x"1234";
signal ram: ram_type;
begin
firstLocation <= ram(0);
process(interrupt,clk) begin
if (interrupt = '1') then
	ISR <= ISRLocation;  -- if interrupt occurs load the interrupt handler from the address of M[1]
elsif (falling_edge(clk)) then
	--iAddress <= to_integer(unsigned((instructionAddress(addressableSpace - 1 downto 0))));
	instruction <= ram(to_integer(unsigned(instructionAddress)) + 1) & ram(to_integer(unsigned(instructionAddress)));
end if;
--instruction <= ram(iAddress);
--ISR <= ISRLocation;	
end process;
end implementInstructionCache;