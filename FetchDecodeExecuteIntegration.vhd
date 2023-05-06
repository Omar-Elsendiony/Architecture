library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity FetchDecodeExecuteIntegration is port
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
end entity;

architecture myFetchDecodeExecuteIntegration of FetchDecodeExecuteIntegration is

	component fetchAndDecodeIntegration is
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
	end component;
	
	
	component ExcuteIntegration is port--with buffers: ID/Exec  and IExec/Mem
	(
		rst,clk: in std_logic;
		src1,src2 : in std_logic_vector(15 downto 0);
		regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus : in std_logic;
		PCSrc,BrType: in std_logic_vector(1 downto 0);
		ALUFn : in std_logic_vector (3 downto 0);
		rdIn : in std_logic_vector (2 downto 0);
		ExecuteResultOut : out std_logic_vector(15 downto 0);
		regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut : out std_logic;
		PCSrcOut,BrTypeOut: out std_logic_vector(1 downto 0);
		FlagRegResultOut:out std_logic_vector(2 downto 0);
		rdOut : out std_logic_vector (2 downto 0);
		src2Propagate : out std_logic_vector (15 downto 0)
	);
	end component;
	
	
	signal src1Sig,src2Sig : std_logic_vector(15 downto 0);
	signal regWriteSig,memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig : std_logic;
	signal PCSrcSig,BrTypeSig: std_logic_vector(1 downto 0);
	signal ALUFnSig: std_logic_vector (3 downto 0);
	signal rdSig : std_logic_vector(2 downto 0);
	
begin
	fetchAndDecodeIntegrationInst: fetchAndDecodeIntegration port map(clk,rst,src1Sig,src2Sig,regWriteSig,memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig,PCSrcSig,BrTypeSig,ALUFnSig,regWriteWB,destVal,destAddress,rdSig);
	ExcuteIntegrationInst: ExcuteIntegration port map(rst,clk,src1Sig,src2Sig,regWriteSig,memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig,PCSrcSig,BrTypeSig,ALUFnSig,rdSig,ExecuteResultOut,regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut,PCSrcOut,BrTypeOut,FlagRegResultOut,rdOut,src2Propagate);
	
end myFetchDecodeExecuteIntegration;


