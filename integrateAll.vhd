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
	-----------------  Forwarding Unit Part and hazard detection unit -----------------------
   
    IDEXE_SrcRs:out std_logic_vector(2 downto 0);  -- Rs that enters the forwarding unit from decode/execute buffer
	 IDEXE_SrcRt:out std_logic_vector(2 downto 0);  -- Rt that enters the forwarding unit from decode/execute buffer
	 
	 --  Hazard
	 FETCHDEC_SrcRs : out std_logic_vector(2 downto 0); -- Rs that enters HDU from fetch/decode buffer 
	 FETCHDEC_SrcRt : out std_logic_vector(2 downto 0); -- Rt that enters HDU from fetch/decode buffer 
	

	 RsSelector : in std_logic_vector(1 downto 0) := "00";
	 RtSelector : in std_logic_vector(1 downto 0) := "00";
	 
	 MEM1MEM2Result : in std_logic_vector(15 downto 0);

	 pc_Src : out std_logic_vector (1 downto 0);
	 branch_signal : out std_logic;
	 programCounter : out std_logic_vector(15 downto 0) -- program counter before incrementing
	 
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
			regDstValue : out std_logic_vector (15 downto 0);
			---------- added in phase 3 -----------------------
			 MEM1MEM2_Rd:out std_logic_vector(2 downto 0);
			 MEM1MEM2_RegWrite:out std_logic;  -- reg write in buffer
			 --EXEMEM1_RegWrite:out std_logic;  -- reg write in buffer
			 --EXEMEM1_Rd:out std_logic_vector(2 downto 0);
			 --WB_Rd:out std_logic_vector(2 downto 0);
			 --WB_RegWrite:out std_logic;
			 --MemRead1 : out std_logic;  -- memRead in ExecuteMEMBuffer that enters HDU
			 --MemRead2 : out std_logic  -- memRead in MEM1MEM2Buffer that enters HDU
			MEM1MEM2Result : out std_logic_vector(15 downto 0)

			);
	end component;
	
	component HDU is port
	(
		EXEMEMDst : in std_logic_vector(2 downto 0);
		IDEXEDst : in std_logic_vector(2 downto 0);
		MemRead1 : in std_logic;  -- memRead in decodeExecuteBuffer
		MemRead2 : in std_logic;  -- memRead in mem1mem2Buffer
		
		Rs : in std_logic_vector(2 downto 0);
		Rt : in std_logic_vector(2 downto 0);
		flush: out std_logic
		
	);
	end component;
	
	component forwardingUnit is
	  port (
		 MEM1MEM2_Rd:in std_logic_vector(2 downto 0);
		 MEM1MEM2_RegWrite:in std_logic;
		 EXEMEM1_RegWrite:in std_logic;
		 EXEMEM1_Rd:in std_logic_vector(2 downto 0);
		 WB_Rd:in std_logic_vector(2 downto 0);
		 WB_RegWrite:in std_logic;
		 DECEXE_Src:in std_logic_vector(2 downto 0);
		 FUsignal:out std_logic_vector(1 downto 0)
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
	signal flush: std_logic;
	
	signal IDEXE_SrcRs,IDEXE_SrcRt,FETCHDEC_SrcRs,FETCHDEC_SrcRt: std_logic_vector(2 downto 0);
	
	signal MEM1MEM2Result:  std_logic_vector (15 downto 0);
	
	signal MEM1MEM2_Rd: std_logic_vector (2 downto 0);
	signal MEM1MEM2_RegWrite : std_logic;
	
	signal EXEMEM1_Rd: std_logic_vector (2 downto 0);
	signal EXEMEM1_RegWrite : std_logic;
	
	signal rsSelector,rtSelector :  std_logic_vector (1 downto 0);
	
begin
	-- execute result out holds the value from exemem buffer
	fde : FetchDecodeExecuteIntegration port map (clk,rst,flush,regWrite,destVal,destAddress,
	ExecuteResultOut,regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusout,
	PCSrcOut,BrTypeOut,flagReg,rdTemp1,src2Propagate,IDEXE_SrcRs,IDEXE_SrcRt,FETCHDEC_SrcRs,FETCHDEC_SrcRt,RSselector,rtSelector,mem1MEM2Result);
	 
	EXEMEM1_Rd <= rdTemp1;
	EXEMEM1_RegWrite <= regWriteOut;
	 
	mmwb : memoryAndWriteBackIntegration port map (clk,rst,memReadOut,memWriteOut,SPEnOut,
	SPStatusOut,RegInSrcOut,regWriteOut,
	ExecuteResultOut,src2Propagate,rdTemp1,destAddress,regWrite,destVal,MEM1MEM2_Rd,MEM1MEM2_RegWrite,MEM1MEM2Result);
	
	--HDUInst : HDU port map ()
	
	FUSrc_1 : forwardingUnit port map ( MEM1MEM2_Rd,MEM1MEM2_RegWrite, 
			 EXEMEM1_RegWrite,EXEMEM1_Rd,destAddress,regWrite,IDEXE_SrcRs,RsSelector);
--			 
	FUSrc_2 : forwardingUnit port map ( MEM1MEM2_Rd,MEM1MEM2_RegWrite, 
			 EXEMEM1_RegWrite,EXEMEM1_Rd,destAddress,regWrite,IDEXE_SrcRt,RtSelector);
	
	--flush the buffer
end integraaaate;


