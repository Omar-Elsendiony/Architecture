library IEEE,std;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity HDUSrcesBuffer is
	port(clk: in std_logic;
		SrcsIn: in std_logic_vector(1 downto 0);
		SrcsOut : out std_logic_vector(1 downto 0)
		);
end entity;

ARCHITECTURE implo oF HDUSrcesBuffer IS
begin
process(clk) begin
if (rising_edge(clk)) then
	SrcsOut <= SrcsIn;
end if;
	
end process;
end architecture;