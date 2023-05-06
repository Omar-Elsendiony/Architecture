LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY peripherals IS
PORT(IORead,IOWrite : IN std_logic; outPort:in std_logic_vector(15 downto 0); inPort : OUT std_logic_vector(15 downto 0));
END peripherals;
ARCHITECTURE p OF peripherals IS

signal portValue: std_logic_vector(15 downto 0);

BEGIN
PROCESS(IORead,IOWrite)
BEGIN
IF(IORead = '1') THEN
	inPort <= portValue; -- in port 
ELSIF (IOWrite = '1') THEN
	portValue <= outPort;
END IF;
END PROCESS;
END p;