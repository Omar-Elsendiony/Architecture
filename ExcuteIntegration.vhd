library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity ExcuteIntegration is port--with buffers: ID/Exec  and IExec/Mem
(
	rst,clk,flush: in std_logic;
	src1,src2 : in std_logic_vector(15 downto 0);
	regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,ioWrite : in std_logic;--added ioWrite ky
	PCSrc,BrType: in std_logic_vector(1 downto 0);
	ALUFn : in std_logic_vector (3 downto 0);
	rdIn : in std_logic_vector (2 downto 0);
	ExecuteResultOut : out std_logic_vector(15 downto 0);
	regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut,ioWriteOut : out std_logic;--added ioWriteOut ky
	PCSrcOut,BrTypeOut: out std_logic_vector(1 downto 0);
	FlagRegResultOut:out std_logic_vector(2 downto 0);
	rdOut : out std_logic_vector (2 downto 0);
	src2Propagate : out std_logic_vector (15 downto 0);
	rsBufferIn,rtBufferIn : in std_logic_vector (2 downto 0);
		-----------------  Forwarding Unit Part -----------------------  
    IDEXE_SrcRs:out std_logic_vector(2 downto 0);  -- Rs that enters the forwarding unit from decode/execute buffer
	 IDEXE_SrcRt:out std_logic_vector(2 downto 0);  -- Rt that enters the forwarding unit from decode/execute buffer	
	 IDEXE_SrcRd:out std_logic_vector(2 downto 0);  -- Rd that enters the forwarding unit from decode/execute buffer	ky
	 
	 MEM1MEM2Result : in std_logic_vector(15 downto 0);
		
	 RsSelector : in std_logic_vector(1 downto 0);  --FORWAAAAAAAAAAAAAAAAAAAARD
	 RtSelector : in std_logic_vector(1 downto 0);  --FORWAAAAAAAAAAAAAAAAAAAARD
		
	 MEMWBResult : in std_logic_vector(15 downto 0);
	 memReadHDU : out std_logic; 
	  memWriteHDU : out std_logic;
	 --pc_Src : out std_logic_vector (1 downto 0);  -- fetch decode not hereee
	 branch_signal : out std_logic
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
		FlagRegOut:out std_logic_vector(2 downto 0);
		EXEMEMResult : in std_logic_vector(15 downto 0);
		MEM1MEM2Result : in std_logic_vector(15 downto 0);
		MEMWBResult :  in std_logic_vector(15 downto 0);
		RsSelector : in std_logic_vector(1 downto 0);  --FORWAAAAAAAAAAAAAAAAAAAARD
	   RtSelector : in std_logic_vector(1 downto 0);  --FORWAAAAAAAAAAAAAAAAAAAARD
	 	BrType : in std_logic_vector(1 downto 0);
		BrOutput: out std_logic;
		rtAfterFU:out std_logic_vector(15 downto 0);
		jumpAddress : out std_logic_vector(15 downto 0)

	);
	end component;
	component IDExe is port
	(
		clk,flush: in std_logic;
		src1,src2 : in std_logic_vector(15 downto 0);
		regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,ioWrite : in std_logic; --added ioWrite ky
		PCSrc,BrType: in std_logic_vector(1 downto 0);
		ALUFn : in std_logic_vector (3 downto 0);
		rdIn : in std_logic_vector (2 downto 0);
		src1Out,src2Out : out std_logic_vector(15 downto 0);
		regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut,ioWriteOut : out std_logic;--added ioWriteOut ky
		PCSrcOut,BrTypeOut: out std_logic_vector(1 downto 0);
		ALUFnOut: out std_logic_vector (3 downto 0);
		rdOut : out std_logic_vector (2 downto 0);
		rsBufferIn,rtBufferIn : in std_logic_vector (2 downto 0);
		rsBufferOut,rtBufferOut : out std_logic_vector (2 downto 0)
	);
	end component;
	
component IExeMem is port
(
	clk: in std_logic;
	ExecuteResult: in std_logic_vector(15 downto 0);
	FlagRegResult:in std_logic_vector(2 downto 0);
	regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,ioWrite : in std_logic;--added ioWrite ky
	PCSrc,BrType: in std_logic_vector(1 downto 0);
	rdIn : in std_logic_vector (2 downto 0);
	ExecuteResultOut : out std_logic_vector(15 downto 0);
	regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut,ioWriteOut : out std_logic;--added ioWriteOut ky
	PCSrcOut,BrTypeOut: out std_logic_vector(1 downto 0);
	FlagRegResultOut:out std_logic_vector(2 downto 0);
	rdOut : out std_logic_vector (2 downto 0);
	src2In : in std_logic_vector(15 downto 0);
	src2Out : out std_logic_vector(15 downto 0)
);
end component;
	
	signal src1Sig,src2Sig : std_logic_vector(15 downto 0);
	signal regWriteSig,memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig,ioWriteSig : std_logic;--added ioWriteSig ky
	signal PCSrcSig,BrTypeSig: std_logic_vector(1 downto 0);
	--alu signals
	signal ALUFnSig: std_logic_vector (3 downto 0);
	signal ALUResultSig: std_logic_vector(15 downto 0);
	signal FlagRegOutSig: std_logic_vector (2 downto 0);
	signal rdTemp : std_logic_vector (2 downto 0);
	
	signal executeResultOutTemp: std_logic_vector(15 downto 0);
	signal rtAfterFuSig : std_logic_vector(15 downto 0);
	signal branchResult: std_logic;
begin


	IDExeBufferinst:IDExe port map(clk,flush,src1,src2,regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,ioWrite,PCSrc,
	BrType,ALUFn,rdIn,src1Sig,src2Sig,regWriteSig,memWriteSig,memReadSig,RegInSrcSig,
	SPEnSig,SPStatusSig,ioWriteSig,PCSrcSig,BrTypeSig,ALUFnSig,rdTemp,rsBufferIn,rtBufferIn,IDEXE_SrcRs,IDEXE_SrcRt);
	
	memReadHDU <= memReadSig;
	memWriteHDU <= memWriteSig;  --from decode/execute buffer
	-- for forward unit inst OUT ky
	IDEXE_SrcRd<=rdTemp;
	--execute result enter execute stage
	----------------------------------------------------------------------------------------------------------- executeResultOutTemp is ex/mem
	ExcuteStageinst:ExcuteStage port map(rst,clk,src1Sig,src2Sig,ALUFnSig,ALUResultSig,FlagRegOutSig,
	executeResultOutTemp,MEM1MEM2Result,MEMWBResult,RsSelector,RtSelector,BrTypeSig,branch_signal,rtAfterFuSig);
	
	IExeMeminst:IExeMem port map(clk,ALUResultSig,FlagRegOutSig,regWriteSig,memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig,ioWriteSig,
	PCSrcSig,BrTypeSig,rdTemp,executeResultOutTemp,regWriteOut,
	memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut,ioWriteOut,PCSrcOut,BrTypeOut,FlagRegResultOut,rdOut,rtAfterFuSig,src2Propagate);
	
	executeResultOut <= executeResultOutTemp;
	


end myExcuteIntegration;