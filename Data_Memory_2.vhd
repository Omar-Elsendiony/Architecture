LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
--The instructions that will use memory are load,store
ENTITY Data_Memory_2 IS generic (n:integer:=16);
PORT (clk:in std_logic;
	memValIn : in std_logic_vector(15 downto 0);
	memValOut : out std_logic_vector(15 downto 0)
);
END ENTITY ;
ARCHITECTURE dm2 OF Data_Memory_2 IS 

BEGIN
PROCESS(clk) IS 
BEGIN
IF falling_edge(clk) THEN
	memValOut <= memValIn;
END IF;
END PROCESS;

END dm2;
