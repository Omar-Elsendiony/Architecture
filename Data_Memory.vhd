LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
--The instructions that will use memory are load,store
ENTITY Data_Memory IS generic (n:integer:=16);
PORT (clk,rst : IN std_logic;
memread,memwrite : IN std_logic;
address : IN std_logic_vector(9 DOWNTO 0);
memwritedata: IN std_logic_vector(n-1 DOWNTO 0);
dataout : OUT std_logic_vector(n-1 DOWNTO 0) 
);
END ENTITY ;
ARCHITECTURE sync_ram_a OF Data_Memory IS 
TYPE ram_type IS ARRAY(0 TO 1023) of std_logic_vector(n-1 DOWNTO 0);
SIGNAL ram : ram_type ;
BEGIN
PROCESS(clk,rst) IS 
BEGIN
IF(rst='1') then
	ram<=(others=>(others=>'0'));
	dataout<=(others=>'0');
ELSIF falling_edge(clk) THEN
	IF memwrite = '1' THEN
		ram(to_integer(unsigned(address)))<= memwritedata; 
	ELSIF memread='1' THEN
		dataout <= ram(to_integer(unsigned(address)));
	END IF;
END IF;
END PROCESS;

END sync_ram_a;
