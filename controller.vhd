LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY controller IS
PORT (opCode : IN std_logic_vector(4 downto 0);
regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus : OUT std_logic; -- that will propagate
IORead,IOWrite,RegDst:out std_logic;
ALUFn : out std_logic_vector (3 downto 0);
PCSrc,ALUSrc,BrType: out std_logic_vector (1 downto 0)
 );
END ENTITY controller;

ARCHITECTURE implementDFF OF controller IS
begin

process (opCode) is
begin
if (opCode = "00000") then  --NOP
	regWrite <= '0';memWrite <= '0';memRead <= '0';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1001";
elsif (opCode = "00110") then  --INC takes from ALU
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0000";

elsif (opCode = "01000") then  --ADD takes from ALU
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0001";	
elsif (opCode = "01011") then  --AND takes from ALU
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0101";	

elsif (opCode = "00100") then  --IN 
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";IORead <= '1';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0110";		
	

elsif (opCode = "10011") then  --LDD address Rs and Dest Rt
	regWrite <= '1';memWrite <= '0';memRead <= '1';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "0110";

elsif (opCode = "10100") then  --STD Stores  Rs address -- Rt value
	regWrite <= '0';memWrite <= '1';memRead <= '0';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0110";
	
else
	regWrite <= '0';memWrite <= '0';memRead <= '0';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1001";
	
end if;



end process;


END implementDFF;