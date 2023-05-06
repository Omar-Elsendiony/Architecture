LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY registerFile IS
PORT (clk,rst : IN std_logic;
regWrite : IN std_logic;
rsAddress : IN std_logic_vector(2 DOWNTO 0);
rtAddress : IN std_logic_vector(2 DOWNTO 0);
regDst : IN std_logic_vector(2 DOWNTO 0);
destVal : IN std_logic_vector(15 DOWNTO 0);
rsOut : OUT std_logic_vector(15 DOWNTO 0);
rtOut : OUT std_logic_vector(15 DOWNTO 0)
 );
END ENTITY;

ARCHITECTURE implementDFF OF registerFile IS
TYPE ram_type IS ARRAY(0 TO 7) of std_logic_vector(15 DOWNTO 0);
SIGNAL ram : ram_type ;
constant zeros : std_logic_vector(15 downto 0) := (others => '0');
BEGIN
PROCESS(clk,rst,regWrite) IS
BEGIN
	if rst = '1' THEN
		ram <= (others => (others=> '0'));
	--elsif (regWrite = '1') then
		--ram(to_integer(unsigned((regDst)))) <= destVal;
	elsIF falling_edge(clk) THEN
		IF regWrite = '1' THEN
			ram(to_integer(unsigned((regDst)))) <= destVal;
		END IF;
	END IF;
END PROCESS;
rsOut <= ram(to_integer(unsigned((rsAddress))));
rtOut <= ram(to_integer(unsigned((rtAddress))));

END implementDFF;