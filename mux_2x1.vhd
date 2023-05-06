LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux_2x1 IS 
	Generic ( n : Integer:=16);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END mux_2x1;


ARCHITECTURE when_else_mux OF mux_2x1 is
	BEGIN
		
  out1 <= in0 when sel = '0'
	else	in1;
END when_else_mux;


--ARCHITECTURE with_select_mux OF mux_2x1 is
--	BEGIN
--		
--with Sel select
--	out1 <= in0 when "00",
--		in1 when "01",
--		in2 when "10",
--		in3 when others;
--END with_select_mux;

 --SIGNAL bus : bit_vector(0 TO 7) := (4=>'1', OTHERS=>'0');  -- default value 
		-- of "bus" is B"0000_1000"