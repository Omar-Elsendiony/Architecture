LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY CCR IS
	PORT(rst,clk : IN std_logic; 
		inFlag:in std_logic_vector(2 downto 0); outFlag : OUT std_logic_vector(2 downto 0));
	END CCR;
ARCHITECTURE myccr OF CCR IS

--signal portValue: std_logic_vector(15 downto 0);

BEGIN
	PROCESS(rst,clk)
	BEGIN
		IF(rst = '1') THEN
			outFlag <= (others=>'0');
		ELSIF (rising_edge(clk)) THEN
			outFlag <= inFlag;
		END IF;
	END PROCESS;
END myccr;