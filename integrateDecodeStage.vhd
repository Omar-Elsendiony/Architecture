library IEEE,std;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity integrateDecodeStage is
	generic (addressableSpace : integer:= 10 ; wordSize: integer:= 16);
	port(clk,rst: in std_logic;
		--instructionAddress: in std_logic_vector(wordSize - 1 downto 0);
		opCode: in std_logic_vector(4 downto 0);
		rs: in std_logic_vector (2 downto 0);
		rt: in std_logic_vector (2 downto 0);
		rd: in std_logic_vector (2 downto 0);
		incPC: in std_logic_vector(15 downto 0);
		immediateVal: in std_logic_vector((wordSize)-1 downto 0);
		src1,src2 : out std_logic_vector(15 downto 0);
		regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus : OUT std_logic;
		PCSrc,BrType: out std_logic_vector(1 downto 0);
		ALUFn : out std_logic_vector (3 downto 0);
		regWriteWB: in std_logic;
		destVal : in std_logic_vector(15 downto 0);
		destAddress: in std_logic_vector(2 downto 0);
		rdOut : out std_logic_vector (2 downto 0)
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
PCSrc,ALUSrc,BrType: out std_logic_vector (1 downto 0)
 );
END component controller;

signal ioRead,ioWrite,regDst : std_logic;
signal inPort,outPort : std_logic_vector(15 downto 0);
signal src1Temp,src2Temp : std_logic_vector(15 downto 0);
signal ALUSrc : std_logic_vector(1 downto 0);
begin

regfile : registerFile port map (clk,rst,regWriteWB,rs,rt,destAddress,destVal,src1Temp,src2Temp);
cont : controller port map (opCode,regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,ioRead,ioWrite,regDst,ALUFn,
PCSrc,ALUSrc,BrType);

perif : peripherals port map(ioRead,ioWrite,src1Temp,inPort);

rsOrInPort: mux_2x1 port map(src1Temp,inPort,IORead,src1);
regDstMUX: mux_2x1 generic map(3) port map(rd,rd,regDst,rdOut);
rtOrImmediateOrPC: mux port map(src2Temp,immediateVal,incPC,src2Temp,ALUSrc,src2);

end architecture;