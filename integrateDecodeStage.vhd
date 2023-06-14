library IEEE,std;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity integrateDecodeStage is
	generic (addressableSpace : integer:= 10 ; wordSize: integer:= 16);
	port(clk,rst,flush: in std_logic;
		--instructionAddress: in std_logic_vector(wordSize - 1 downto 0);
		opCode: in std_logic_vector(4 downto 0);
		rs: in std_logic_vector (2 downto 0);
		rt: in std_logic_vector (2 downto 0);
		rd: in std_logic_vector (2 downto 0);
		incPC: in std_logic_vector(15 downto 0);
		immediateVal: in std_logic_vector((wordSize)-1 downto 0);
		src1,src2 : out std_logic_vector(15 downto 0);
		regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,ioWriteOut : OUT std_logic;-- added ioWrite ky
		PCSrc,BrType,SrcsHDU: out std_logic_vector(1 downto 0);
		ALUFn : out std_logic_vector (3 downto 0);
		regWriteWB: in std_logic;
		destVal : in std_logic_vector(15 downto 0);
		destAddress: in std_logic_vector(2 downto 0);
		rdOut : out std_logic_vector (2 downto 0);
		rSS: out std_logic_vector (2 downto 0);
		rtt: out std_logic_vector (2 downto 0)
		);
end entity;

Architecture implementD of integrateDecodeStage is

component registerFile IS
PORT (clk,rst : IN std_logic;
regWrite : IN std_logic;
rsAddress : IN std_logic_vector(2 DOWNTO 0);
rtAddress : IN std_logic_vector(2 DOWNTO 0);
regDst : IN std_logic_vector(2 DOWNTO 0);
destVal : IN std_logic_vector(15 DOWNTO 0);
rsOut : OUT std_logic_vector(15 DOWNTO 0);
rtOut : OUT std_logic_vector(15 DOWNTO 0)
 );
END component;

component mux IS 
	Generic ( n : Integer:=16);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END component;

component peripherals IS
PORT(IORead,IOWrite : IN std_logic; outPort:in std_logic_vector(15 downto 0); 
inPort : OUT std_logic_vector(15 downto 0));
END component;

--signal rsAddress,rtAddress,regDst ,destVal,rsOut,rtOut,
component mux_2x1 IS 
	Generic ( n : Integer:=16);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END component;


component controller IS
PORT (opCode : IN std_logic_vector(4 downto 0);
regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus : OUT std_logic; -- that will propagate
IORead,IOWrite,RegDst:out std_logic;
ALUFn : out std_logic_vector (3 downto 0);
PCSrc,ALUSrc,BrType,SrcsHDU: out std_logic_vector (1 downto 0)
 );
END component controller;

signal ioRead,ioWrite,regDst : std_logic;
signal inPort,outPort : std_logic_vector(15 downto 0);
signal src1Temp,src2Temp : std_logic_vector(15 downto 0);
signal ALUSrc : std_logic_vector(1 downto 0);


signal regWriteTemp,memWriteTemp,memReadTemp,RegInSrcTemp,SPEnTemp,SPStatusTemp,ioReadTemp,ioWriteTemp,regDstTemp: std_logic;
signal ALUFnTemp: std_logic_vector(3 downto 0);
signal BrTypeTemp : std_logic_vector (1 downto 0);
constant zeros: std_logic_vector (14 downto 0) := (others => '0');
signal myChoice : std_logic_vector (14 downto 0);
signal inputMux : std_logic_vector (14 downto 0);

signal flushTemp : std_logic := '0';
signal flushEnter : std_logic;
begin

--flushEnter <= not flush;

inputMux <= regWriteTemp & memWriteTemp & memReadTemp & RegInSrcTemp &
SPEnTemp & SPStatusTemp & ioReadTemp & ioWriteTemp & regDstTemp & ALUFnTemp & BrTypeTemp;

regfile : registerFile port map (clk,rst,regWriteWB,rs,rt,destAddress,destVal,src1Temp,src2Temp);
cont : controller port map (opCode,regWriteTemp,memWriteTemp,memReadTemp,RegInSrcTemp,
SPEnTemp,SPStatusTemp,ioReadTemp,ioWriteTemp,regDstTemp,ALUFnTemp,PCSrc,ALUSrc,BrTypeTemp,SrcsHDU);

hazardDetectionUnitChoice : mux_2x1 generic map(15) port map (inputMux,zeros,flush,myChoice);

regWrite  <= myChoice(14);
memWrite  <= myChoice(13);
memRead  <= myChoice(12);
RegInSrc  <= myChoice(11);
SPEn <= myChoice(10);
SPStatus <= myChoice(9);
ioRead <= myChoice(8);
ioWrite <= myChoice(7);
regDst <= myChoice(6);
ALUFn <= "1001" when flush= '1' 
else myChoice (5 downto 2);
BrType <= myChoice(1 downto 0);
rSS <= rs;
rtt <= rt;

perif : peripherals port map(ioRead,ioWrite,src1Temp,inPort);

rsOrInPort: mux_2x1 port map(src1Temp,inPort,IORead,src1);
regDstMUX: mux_2x1 generic map(3) port map(rd,rd,regDst,rdOut);
rtOrImmediateOrPC: mux port map(src2Temp,immediateVal,incPC,src2Temp,ALUSrc,src2);

--send ioWrite signal to the buffer IDEXEC     ky
ioWriteOut<=ioWrite;

end architecture;