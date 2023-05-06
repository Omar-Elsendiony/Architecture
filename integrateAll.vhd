library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity integrateAll is port
(
	clk,rst: in std_logic

);
end entity;

architecture integraaaate of integrateAll is

	component FetchDecodeExecuteIntegration is port
	(
		clk,rst: in std_logic;
		regWriteWB: in std_logic;
		destVal : in std_logic_vector(15 downto 0);
		destAddress: in std_logic_vector(2 downto 0);
		
		ExecuteResultOut : out std_logic_vector(15 downto 0);
		regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut : out std_logic;
		PCSrcOut,BrTypeOut: out std_logic_vector(1 downto 0);
		FlagRegResultOut:out std_logic_vector(2 downto 0);
		rdOut: out std_logic_vector(2 downto 0);
		src2Propagate : out std_logic_vector(15 downto 0)
	);
	end component;
	
	component memoryAndWriteBackIntegration is
	generic (addressableSpace : integer:= 10 ; wordSize: integer:= 16);
		port(clk,rst: in std_logic;
			memRead,memWrite,spEn,spStatus,RegInSrc,RegWrite : in std_logic;
			ALUResult: in std_logic_vector(15 downto 0);
			rtOrPC : in std_logic_vector(15 downto 0);
			rd : in std_logic_vector (2 downto 0);
			regDst: out std_logic_vector (2 downto 0);
			regWriteOutOfintegration : out std_logic;
			regDstValue : out std_logic_vector (15 downto 0)
			);
	end component;
	
	
	
	signal ExecuteResultOut :  std_logic_vector(15 downto 0);
	signal regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut,regWrite :  std_logic;
	--PCSrcOut,BrTypeOut: in std_logic_vector(1 downto 0);
	--signal FlagRegResultOut:  std_logic_vector(2 downto 0);
	signal rdTemp1:  std_logic_vector(2 downto 0);
	signal src2Propagate:  std_logic_vector(15 downto 0);
	signal destVal: std_logic_vector(15 downto 0);
	signal destAddress: std_logic_vector(2 downto 0);
	
	signal flagReg: std_logic_vector(2 downto 0);

	signal regDstLast:  std_logic_vector (2 downto 0);
	signal regWriteLast :  std_logic;
	signal regDstValueLast :  std_logic_vector (15 downto 0);
	signal PCSrcOut,BrTypeOut:  std_logic_vector(1 downto 0);
begin
	fde : FetchDecodeExecuteIntegration port map (clk,rst,regWrite,destVal,destAddress,
	ExecuteResultOut,regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusout,PCSrcOut,BrTypeOut,flagReg,rdTemp1,src2Propagate);
--	
	mmwb : memoryAndWriteBackIntegration port map (clk,rst,memReadOut,memWriteOut,SPEnOut,SPStatusOut,RegInSrcOut,regWriteOut,
	ExecuteResultOut,src2Propagate,rdTemp1,destAddress,regWrite,destVal);
	
end integraaaate;


