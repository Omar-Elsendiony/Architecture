library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity FetchDecodeExecuteIntegration is port
(
	clk,rst,flush: in std_logic;
	clearBuffer : in std_logic;
	regWriteWB: in std_logic;
	destVal : in std_logic_vector(15 downto 0);
	destAddress: in std_logic_vector(2 downto 0);
	
	ExecuteResultOut : out std_logic_vector(15 downto 0);
	regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut,ioWriteOut : out std_logic;--added ioWriteOut ky
	PCSrcOut,BrTypeOut,SrcsHDU: out std_logic_vector(1 downto 0);
	FlagRegResultOut:out std_logic_vector(2 downto 0);
	rdOut: out std_logic_vector(2 downto 0);
	src2Propagate : out std_logic_vector(15 downto 0);
	-------------------------------------------------------------------------------------
	IDEXE_SrcRs:out std_logic_vector(2 downto 0);  -- Rs that enters the forwarding unit from decode/execute buffer
	 IDEXE_SrcRt:out std_logic_vector(2 downto 0);  -- Rt that enters the forwarding unit from decode/execute buffer
	 IDEXE_SrcRd:out std_logic_vector(2 downto 0);  -- Rd that enters the forwarding unit from decode/execute buffer ky
	 
	 FETCHDEC_SrcRs : out std_logic_vector(2 downto 0); -- Rs that enters HDU from fetch/decode buffer 
	 FETCHDEC_SrcRt : out std_logic_vector(2 downto 0); -- Rt that enters HDU from fetch/decode buffer 
	 FETCHDEC_MemRead : out std_logic;
	 FETCHDEC_MemWrite : out std_logic;
	 
	 RsSelector : in std_logic_vector(1 downto 0);  --FORWAAAAAAAAAAAAAAAAAAAARD
	 RtSelector : in std_logic_vector(1 downto 0);  --FORWAAAAAAAAAAAAAAAAAAAARD
	 
	 MEM1MEM2Result : in std_logic_vector(15 downto 0);
	 programCounter : out std_logic_vector(15 downto 0); -- program counter before incrementing
	 
	 addressComing: in std_logic_vector(15  downto 0);
	 interruptSignal : in std_logic;
	 
	 --------- start here
	 pc_Src : out std_logic_vector (1 downto 0);
	 memReadHDU,memWriteHDU : out std_logic; 
	 
	 branch_signal : out std_logic;
	 jumpAddress : out std_logic_vector(15 downto 0)
);
end entity;

architecture myFetchDecodeExecuteIntegration of FetchDecodeExecuteIntegration is

	component fetchAndDecodeIntegration is
	generic (addressableSpace : integer:= 10 ; wordSize: integer:= 16);
	port(clk,rst,flush: in std_logic;
	   clearBuffer : in std_logic;
		src1,src2 : out std_logic_vector(15 downto 0);
		regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,ioWrite : OUT std_logic;--added iowrite ky
		PCSrc,BrType,SrcsHDU: out std_logic_vector(1 downto 0);
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
	 	programCounter : out std_logic_vector(15 downto 0); -- program counter before incrementing
		addressComing: in std_logic_vector(wordSize - 1  downto 0);
		interruptSignal : in std_logic
		
		
		);
	end component;
	
	
	component ExcuteIntegration is port--with buffers: ID/Exec  and IExec/Mem
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
	 branch_signal : out std_logic;
	 jumpAddress : out std_logic_vector(15 downto 0)
	);
	end component;
	
	
	signal src1Sig,src2Sig : std_logic_vector(15 downto 0);
	signal regWriteSig,memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig,ioWriteSig,ioWriteSig2 : std_logic;--added ioWriteSig ky
	signal PCSrcSig,BrTypeSig: std_logic_vector(1 downto 0);
	signal ALUFnSig: std_logic_vector (3 downto 0);
	signal rdSig : std_logic_vector(2 downto 0);
	
	signal rsOutSign : std_logic_vector(2 downto 0);  
	signal rtOutSign : std_logic_vector(2 downto 0);
	
begin
	fetchAndDecodeIntegrationInst: fetchAndDecodeIntegration port map(clk,rst,flush,clearBuffer,src1Sig,src2Sig,regWriteSig,
	memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig,ioWriteSig,PCSrcSig,BrTypeSig,SrcsHDU,ALUFnSig,regWriteWB,destVal,
	destAddress,rdSig,rsOutSign,rtOutSign,programCounter,addressComing,interruptSignal);--added ioWriteSig ky
	
	FETCHDEC_SrcRs <= rsOutSign;
	FETCHDEC_SrcRt <= rtOutSign;
	FETCHDEC_MemRead <= memReadSig;
	FETCHDEC_MemWrite <= memWriteSig;
	pc_Src <= PCSrcSig;
	
	ExcuteIntegrationInst: ExcuteIntegration port map(rst,clk,flush,src1Sig,src2Sig,
	regWriteSig,memWriteSig,memReadSig,RegInSrcSig,SPEnSig,SPStatusSig,ioWriteSig,PCSrcSig,BrTypeSig,ALUFnSig,rdSig,ExecuteResultOut,regWriteOut,
	memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut,ioWriteSig2,PCSrcOut,BrTypeOut,FlagRegResultOut,rdOut,
	src2Propagate,rsOutSign,rtOutSign,IDEXE_SrcRs,IDEXE_SrcRt,IDEXE_SrcRd,MEM1MEM2Result,RsSelector,RtSelector,
	destVal,memReadHDU,memWriteHDU,branch_signal,jumpAddress);
	
	--memWrite after d.e
	
	
	--added ioWriteSig ky
	--destVal is memWB value
	
	ioWriteOut<=ioWriteSig2;
	
end myFetchDecodeExecuteIntegration;


