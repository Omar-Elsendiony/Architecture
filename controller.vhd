LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY controller IS
PORT (opCode : IN std_logic_vector(4 downto 0);
regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus : OUT std_logic; -- that will propagate
IORead,IOWrite,RegDst:out std_logic;
ALUFn : out std_logic_vector (3 downto 0);
PCSrc,ALUSrc,BrType,SrcsHDU: out std_logic_vector (1 downto 0)

--SrcsHDU: 2 bits that tells you what srcs you will read 
--this is needed in the HDU only to not stall until you read the Rdst of the previous LDD/POP instructions
--the first bit for Rs ,second bit for Rt
--example if you are an instruction that reads RS onlu so SrcsHDU=10
 );
END ENTITY controller;

ARCHITECTURE implementDFF OF controller IS
begin

process (opCode) is
begin
if (opCode = "00000") then  --NOP
	regWrite <= '0';memWrite <= '0';memRead <= '0';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="00";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1001";
elsif (opCode = "00001") then  --SETC takes from ALU
	regWrite <= '0';memWrite <= '0';memRead <= '0';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="00";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1010";
elsif (opCode = "00011") then  --CLRC takes from ALU
	regWrite <= '0';memWrite <= '0';memRead <= '0';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="00";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1011";
elsif (opCode = "00010") then  --NOT takes from ALU
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="10";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0111";	
elsif (opCode = "00110") then  --INC takes from ALU
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="10";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0000";
elsif (opCode = "00111") then  --DEC takes from ALU
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="10";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0011";	
elsif (opCode = "00101") then  --OUT 
	regWrite <= '0';memWrite <= '0';memRead <= '0';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="10";IORead <= '0';IOWrite <='1';RegDst <= '0';
	ALUFn <= "0110"; --1011 changed ky***** 	
elsif (opCode = "00100") then  --IN 
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="00";IORead <= '1';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0110";			
elsif (opCode = "01111") then  --MOV
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="10";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0110";
elsif (opCode = "01000") then  --ADD takes from ALU
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="11";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0001";	
elsif (opCode = "01010") then  --IADD takes from ALU
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "01";ALUSrc <= "01";BrType <= "00";SrcsHDU<="10";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0001";	
elsif (opCode = "01001") then  --SUB takes from ALU
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="11";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0010";	
	
elsif (opCode = "01011") then  --AND takes from ALU
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="11";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0101";	

elsif (opCode = "01100") then  --OR takes from ALU
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="11";IORead <= '0';IOWrite <='0';RegDst <= '1';
	ALUFn <= "0100";	
	
elsif (opCode = "10000") then  --PUSH takes from ALU
	regWrite <= '0';memWrite <= '1';memRead <= '0';RegInSrc <= '0';SPEn <= '1';SPStatus <= '1';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="01";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1001";
elsif (opCode = "10001") then  --POP takes from ALU
	regWrite <= '1';memWrite <= '0';memRead <= '1';RegInSrc <= '0';SPEn <= '1';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="00";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1001";
elsif (opCode = "10010") then  --LDM 
	regWrite <= '1';memWrite <= '0';memRead <= '0';RegInSrc <= '1';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "01";ALUSrc <= "01";BrType <= "00";SrcsHDU<="00";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1000";

elsif (opCode = "10011") then  --LDD address Rs and Dest Rt
	regWrite <= '1';memWrite <= '0';memRead <= '1';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="10";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "0110";

elsif (opCode = "10100") then  --STD Stores  Rs address -- Rt value
	regWrite <= '0';memWrite <= '1';memRead <= '0';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="11";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "0110";
elsif (opCode = "11000") then  --JZ
	regWrite <= '0';memWrite <= '0';memRead <= '0';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "10";ALUSrc <= "00";BrType <= "01";SrcsHDU<="10";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1001";
elsif (opCode = "11001") then  --JC
	regWrite <= '0';memWrite <= '0';memRead <= '0';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "10";ALUSrc <= "00";BrType <= "10";SrcsHDU<="10";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1001";	
elsif (opCode = "11010") then  --JMP
	regWrite <= '0';memWrite <= '0';memRead <= '0';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "10";ALUSrc <= "00";BrType <= "11";SrcsHDU<="10";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1001";	
elsif (opCode = "11011") then  --CALL
	regWrite <= '0';memWrite <= '1';memRead <= '0';RegInSrc <= '0';SPEn <= '1';SPStatus <= '1';
	PCSrc <= "10";ALUSrc <= "10";BrType <= "11";SrcsHDU<="10";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1001";
elsif (opCode = "11100") then  --RET
	regWrite <= '0';memWrite <= '0';memRead <= '1';RegInSrc <= '0';SPEn <= '1';SPStatus <= '0';
	PCSrc <= "10";ALUSrc <= "00";BrType <= "11";SrcsHDU<="00";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1001";
elsif (opCode = "11101") then  --RETI
	regWrite <= '0';memWrite <= '0';memRead <= '1';RegInSrc <= '0';SPEn <= '1';SPStatus <= '0';
	PCSrc <= "10";ALUSrc <= "00";BrType <= "11";SrcsHDU<="00";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1001";
	
else   --NOP
	regWrite <= '0';memWrite <= '0';memRead <= '0';RegInSrc <= '0';SPEn <= '0';SPStatus <= '0';
	PCSrc <= "00";ALUSrc <= "00";BrType <= "00";SrcsHDU<="00";IORead <= '0';IOWrite <='0';RegDst <= '0';
	ALUFn <= "1001";
	
end if;



end process;


END implementDFF;