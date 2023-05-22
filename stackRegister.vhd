LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
--The instructions that will use memory are load,store
entity stackRegister IS generic (n:integer:=16);
PORT (clk,rst : IN std_logic;
spEn,spStatus : IN std_logic;
spAddress : out std_logic_vector(n-1 DOWNTO 0)
);
END entity ;

ARCHITECTURE sR OF stackRegister IS 

BEGIN
PROCESS(clk,rst) IS 
variable sp : integer:= 1023;
BEGIN
IF(rst='1') then	
	--ram<=(others=>(others=>'0'));
	spAddress <= std_logic_vector(to_unsigned(sp,spAddress'length));
ELSIF rising_edge(clk) THEN
	IF SPEn = '1' THEN
		if (SPStatus = '1') then  --push hence, decrement
			sp := sp - 1;
		elsif (SpStatus = '0') then -- pop hence, increment
			sp := sp + 1;
		end if;
	END IF;
	spAddress <= std_logic_vector(to_unsigned(sp,spAddress'length));
END IF;
END PROCESS;

END sR;
