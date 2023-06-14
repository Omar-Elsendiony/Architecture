library IEEE,std;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity fetchDecodeBuffer is
	generic (wordSize: integer:= 16 ; addressableSpace: integer:= 10);
	port(clk,flush,clearBuffer: in std_logic;
		incrementedPC: in std_logic_vector(wordSize - 1 downto 0);
		instructionIn: in std_logic_vector((wordSize*2) -1 downto 0);
		opCode : out std_logic_vector(4 downto 0);
		rs,rt,rd : out std_logic_vector(2 downto 0);
		immediateVal : out std_logic_vector(wordSize - 1 downto 0);
		incPC : out std_logic_vector(wordSize - 1 downto 0));
end entity;

ARCHITECTURE implementFDB oF fetchDecodeBuffer IS

begin
process(clk) begin
if (rising_edge(clk)) then
	if (flush = '0' or clearBuffer = '1') then
		rs <= instructionIn(10 downto 8);
		rt <= instructionIn(7 downto 5);
		rd <= instructionIn(4 downto 2);
		opCode <= instructionIn(15 downto 11);
		immediateVal <= instructionIn(wordSize*2 - 1 downto 16);
		incPC <= incrementedPC;
	end if;
end if;
	
end process;
end architecture;