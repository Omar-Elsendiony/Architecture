library IEEE,std;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity MEM1MEM2Buffer is
	generic (wordSize: integer:= 16 ; addressableSpace: integer:= 10);
	port(clk: in std_logic;
		RegInSrcIn,RegWriteIn,MemReadIn: in std_logic;
		rdIn : in std_logic_vector(2 downto 0);
		memValIn : in std_logic_vector(15 downto 0);
		ALUResultIn : in std_logic_vector(15 downto 0);
		RegInSrcOut,RegWriteOut,MemReadOut: out std_logic;
		rdOut : out std_logic_vector(2 downto 0);
		memValOut : out std_logic_vector(15 downto 0);
	   ALUResultOut: out std_logic_vector(15 downto 0)
		);
end entity;

ARCHITECTURE implementmem oF MEM1MEM2Buffer IS
signal t1,t2,t3,t4: std_logic;
begin
process(clk) begin
if (rising_edge(clk)) then
	RegInSrcOut <= RegInSrcIn;
	RegWriteOut <= RegWriteIn;
	memReadOut <= memReadIn;
	rdOut <= rdIn;
	ALUResultOut <= ALUResultIn;
	memValOut <= memValIn;
end if;
	
end process;
end architecture;