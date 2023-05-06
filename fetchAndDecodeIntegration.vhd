library IEEE,std;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity fetchAndDecodeIntegration is
	generic (addressableSpace : integer:= 10 ; wordSize: integer:= 16);
	port(clk,rst: in std_logic;
		src1,src2 : out std_logic_vector(15 downto 0);
		regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus : OUT std_logic;
		PCSrc,BrType: out std_logic_vector(1 downto 0);
		ALUFn : out std_logic_vector (3 downto 0);
		regWriteWB: in std_logic;
		destVal : in std_logic_vector(15 downto 0);
		destAddress: in std_logic_vector(2 downto 0);
		rdOut: out std_logic_vector(2 downto 0)
		);
end entity;

Architecture implementFD of fetchAndDecodeIntegration is


component integratePC_IC_FDB is
	generic (addressableSpace : integer:= 10 ; wordSize: integer:= 16);
	port(clk,rst: in std_logic;
		--instructionAddress: in std_logic_vector(wordSize - 1 downto 0);
		opCode: out std_logic_vector(4 downto 0);
		rs: out std_logic_vector (2 downto 0);
		rt: out std_logic_vector (2 downto 0);
		rd: out std_logic_vector (2 downto 0);
		incPC: out std_logic_vector(15 downto 0);
		immediateVal: out std_logic_vector((wordSize)-1 downto 0)
		);
end component;


component integrateDecodeStage is
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
end component;

signal opCode: std_logic_vector(4 downto 0);
signal rs,rt,rd : std_logic_vector(2 downto 0);
signal incPC,immediateVal:std_logic_vector(15 downto 0);

--src1,src2,regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,PCSrc,BrType,ALUFn,regWriteWB,destVal,destAddress


begin

fetch : integratePC_IC_FDB port map (clk,rst,opCode,rs,rt,rd,incPC,immediateVal);
decode : integrateDecodeStage port map (clk,rst,opCode,rs,rt,rd,incPC,immediateVal,
src1,src2,regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,PCSrc,BrType,ALUFn,regWriteWB,destVal,destAddress,rdOut);



end architecture;