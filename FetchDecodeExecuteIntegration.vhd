library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity FetchDecodeExecuteIntegration is port
(
	clk,rst,flush: in std_logic;
	regWriteWB: in std_logic;
	destVal : in std_logic_vector(15 downto 0);
	destAddress: in std_logic_vector(2 downto 0);
	
	ExecuteResultOut : out std_logic_vector(15 downto 0);
	regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut : out std_logic;
	PCSrcOut,BrTypeOut: out std_logic_vector(1 downto 0);
	FlagRegResultOut:out std_logic_vector(2 downto 0);
	rdOut: out std_logic_vector(2 downto 0);
	src2Propagate : out std_logic_vector(15 downto 0);
	-------------------------------------------------------------------------------------
	IDEXE_SrcRs:out std_logic_vector(2 downto 0);  -- Rs that enters the forwarding unit from decode/execute buffer
	 IDEXE_SrcRt:out std_logic_vector(2 downto 0);  -- Rt that enters the forwarding unit from decode/execute buffer
	 
	 FETCHDEC_SrcRs : out std_logic_vector(2 downto 0); -- Rs that enters HDU from fetch/decode buffer 
	 FETCHDEC_SrcRt : out std_logic_vector(2 downto 0); -- Rt that enters HDU from fetch/decode buffer 
	 
	 RsSelector : in std_logic_vector(1 downto 0);  --FORWAAAAAAAAAAAAAAAAAAAARD
	 RtSelector : in std_logic_vector(1 downto 0);  --FORWAAAAAAAAAAAAAAAAAAAARD
	 
	 MEM1MEM2Result : in std_logic_vector(15 downto 0);
	 
	 pc_Src : out std_logic_vector (1 downto 0);
	 branch_signal : out std_logic;
	 programCounter : out std_logic_vector(15 downto 0) -- program counter before incrementing
);
end entity;

architecture myFetchDecodeExecuteIntegration of FetchDecodeExecuteIntegration is

	component fetchAndDecodeIntegration is
	generic (addressableSpace : integer:= 10 ; wordSize: integer:= 16);
	port(clk,rst,flush: in std_logic;
		src1,src2 : out std_logic_vector(15 downto 0);
		regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus : OUT std_logic;
		PCSrc,BrType: out std_logic_vector(1 downto 0);
		ALUFn : out std_logic_vector (3 downto 0);
		regWriteWB: in std_logic;
		destVal : in std_logic_vector(15 downto 0);
		destAddress: in std_logic_vector(2 downto 0);
		rdOut: out std_logic_vector(2 downto 0);
		---------------- Needed -------------------------
		--rsOut : out std_logic_vector(2 downto 0);  -- for hazard detection unit 
		--rtOut : out std_logic_vector(2 downto 0);  -- for hazard detection unit
		FETCHDEC_SrcRs : out std_logic_vector(2 downto 0); -- Rs that enters HDU from fetch/decode buffer 
	 FETCHDEC_SrcRt : out std_logic_vector(2 downto 0); -- Rt that enters HDU from fetch/decode buffer 
	 	 programCounter : out std_logic_vector(15 downto 0) -- program counter before incrementing	 
		);
	end component;
	
	
	component ExcuteIntegration is port--with buffers: ID/Exec  and IExec/Mem
	(
		rst,clk,flush: in std_logic;
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
	src2Propagate : out std_logic_vector (15 downto 0);
	
	rsBufferIn,rtBufferIn : in std_logic_vector (2 downto 0);
	-----------------  Forwarding Unit Part -----------------------  
    IDEXE_SrcRs:out std_logic_vector(2 downto 0);  -- Rs that enters the forwarding unit from decode/execute buffer
	 IDEXE_SrcRt:out std_logic_vector(2 downto 0);  -- Rt that enters the forwarding unit from decode/execute buffer	
	 
	 MEM1MEM2Result : in std_logic_vector(15 downto 0);
		 
	 RsSelector : in std_logic_vector(1 downto 0);  --FORWAAAAAAAAAAAAAAAAAAAARD
	 RtSelector : in std_logic_vector(1 downto 0);  --FORWAAAAAAAAAAAAAAAAAAAARD
		

	 pc_Src : out std_logic_vector (1 downto 0);
	 branch_signal : out std_logic
	);
	end component;
	
	
	signal src1Sig,src2Sig : std_logic_vector(15 downto 0);
	signal regWriteSig,memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig : std_logic;
	signal PCSrcSig,BrTypeSig: std_logic_vector(1 downto 0);
	signal ALUFnSig: std_logic_vector (3 downto 0);
	signal rdSig : std_logic_vector(2 downto 0);
	
	signal rsOutSign : std_logic_vector(2 downto 0);  
	signal rtOutSign : std_logic_vector(2 downto 0);
	
begin
	fetchAndDecodeIntegrationInst: fetchAndDecodeIntegration port map(clk,rst,flush,src1Sig,src2Sig,regWriteSig,
	memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig,PCSrcSig,BrTypeSig,ALUFnSig,regWriteWB,destVal,
	destAddress,rdSig,FETCHDEC_SrcRs,FETCHDEC_SrcRt);
	
	ExcuteIntegrationInst: ExcuteIntegration port map(rst,clk,flush,src1Sig,src2Sig,
	regWriteSig,memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig,PCSrcSig,BrTypeSig,ALUFnSig,rdSig,ExecuteResultOut,regWriteOut,
	memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut,PCSrcOut,BrTypeOut,
	FlagRegResultOut,rdOut,src2Propagate,rsOutSign,rtOutSign,IDEXE_SrcRs,IDEXE_SrcRt,MEM1MEM2Result,RsSelector,RtSelector);
	
	
	
	
end myFetchDecodeExecuteIntegration;


