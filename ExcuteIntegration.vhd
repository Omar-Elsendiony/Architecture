library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity ExcuteIntegration is port--with buffers: ID/Exec  and IExec/Mem
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
end entity;

architecture myExcuteIntegration of ExcuteIntegration is
	component ExcuteStage is port
	(
		rst,clk:in std_logic;
		src1: in std_logic_vector(15 downto 0);
		src2: in std_logic_vector(15 downto 0);
		ALUFn: in std_logic_vector(3 downto 0);
		ALUResult: out std_logic_vector(15 downto 0);
		FlagRegOut:out std_logic_vector(2 downto 0)  
	);
	end component;
	component IDExe is port
	(
		clk: in std_logic;
		src1,src2 : in std_logic_vector(15 downto 0);
		regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus : in std_logic;
		PCSrc,BrType: in std_logic_vector(1 downto 0);
		ALUFn : in std_logic_vector (3 downto 0);
		rdIn : in std_logic_vector (2 downto 0);
		src1Out,src2Out : out std_logic_vector(15 downto 0);
		regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut : out std_logic;
		PCSrcOut,BrTypeOut: out std_logic_vector(1 downto 0);
		ALUFnOut: out std_logic_vector (3 downto 0);
		rdOut : out std_logic_vector (2 downto 0)
	);
	end component;
	
component IExeMem is port
(
	clk: in std_logic;
	ExecuteResult: in std_logic_vector(15 downto 0);
	FlagRegResult:in std_logic_vector(2 downto 0);
	regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus : in std_logic;
	PCSrc,BrType: in std_logic_vector(1 downto 0);
	rdIn : in std_logic_vector (2 downto 0);
	ExecuteResultOut : out std_logic_vector(15 downto 0);
	regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut : out std_logic;
	PCSrcOut,BrTypeOut: out std_logic_vector(1 downto 0);
	FlagRegResultOut:out std_logic_vector(2 downto 0);
	rdOut : out std_logic_vector (2 downto 0);
	src2In : in std_logic_vector(15 downto 0);
	src2Out : out std_logic_vector(15 downto 0)
);
end component;
	
	signal src1Sig,src2Sig : std_logic_vector(15 downto 0);
	signal regWriteSig,memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig : std_logic;
	signal PCSrcSig,BrTypeSig: std_logic_vector(1 downto 0);
	--alu signals
	signal ALUFnSig: std_logic_vector (3 downto 0);
	signal ALUResultSig: std_logic_vector(15 downto 0);
	signal FlagRegOutSig: std_logic_vector (2 downto 0);
	signal rdTemp : std_logic_vector (2 downto 0);
begin
	IDExeBufferinst:IDExe port map(clk,src1,src2,regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,PCSrc,BrType,ALUFn,rdIn,src1Sig,src2Sig,regWriteSig,memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig,PCSrcSig,BrTypeSig,ALUFnSig,rdTemp);
	ExcuteStageinst:ExcuteStage port map(rst,clk,src1Sig,src2Sig,ALUFnSig,ALUResultSig,FlagRegOutSig);
	IExeMeminst:IExeMem port map(clk,ALUResultSig,FlagRegOutSig,regWriteSig,memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig,PCSrcSig,BrTypeSig,rdTemp,ExecuteResultOut,regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut,PCSrcOut,BrTypeOut,FlagRegResultOut,rdOut,src2Sig,src2Propagate);


end myExcuteIntegration;