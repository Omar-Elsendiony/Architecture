library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity integrateAll is port
(
	clk,rst,interrupt: in std_logic;
	outPort: out std_logic_vector (15 downto 0) --output port which is equla to ExcuteResultOut  ky 
);
end entity;

architecture integraaaate of integrateAll is
	
	
	component full_adder is
    generic (
        WIDTH : positive := 8
    );
    port (
        A : in std_logic_vector(WIDTH - 1 downto 0);
        B : in std_logic_vector(WIDTH - 1 downto 0);
        Cin : in std_logic;
        S : out std_logic_vector(WIDTH - 1 downto 0);
        Cout : out std_logic
    );
end component;

	component my_nadder IS
		 generic (n: integer := 3);
		PORT (a,b : IN  std_logic_vector(n-1 downto 0);
				 cin : in std_logic;
			  s : out std_logic_vector(n-1 downto 0);
				  cout : OUT std_logic );
	end component;
	
	
	component FetchDecodeExecuteIntegration is port
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
	-----------------  Forwarding Unit Part and hazard detection unit -----------------------  
    IDEXE_SrcRs:out std_logic_vector(2 downto 0);  -- Rs that enters the forwarding unit from decode/execute buffer
	 IDEXE_SrcRt:out std_logic_vector(2 downto 0);  -- Rt that enters the forwarding unit from decode/execute buffer
	 IDEXE_SrcRd:out std_logic_vector(2 downto 0);  -- Rd that enters the forwarding unit from decode/execute buffer ky
	 --  Hazard
	 FETCHDEC_SrcRs : out std_logic_vector(2 downto 0); -- Rs that enters HDU from fetch/decode buffer 
	 FETCHDEC_SrcRt : out std_logic_vector(2 downto 0); -- Rt that enters HDU from fetch/decode buffer 
	 FETCHDEC_MemRead : out std_logic;
	 FETCHDEC_MemWrite : out std_logic;
	 -- selectors for forwarding unit
	 RsSelector : in std_logic_vector(1 downto 0) := "00";
	 RtSelector : in std_logic_vector(1 downto 0) := "00";	 
	 MEM1MEM2Result : in std_logic_vector(15 downto 0);
	 programCounter : out std_logic_vector(15 downto 0); -- program counter before incrementing
	 addressComing:  std_logic_vector(15  downto 0);
	 interruptSignal : in std_logic; 
	 pc_Src : out std_logic_vector (1 downto 0);
	 memReadHDU,memWriteHDU : out std_logic; 
	 branch_signal : out std_logic;
	 jumpAddress : out std_logic_vector(15 downto 0)
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
   EXEMEMDst : in std_logic_vector(2 downto 0);  -- load use case
	IDEXEDst : in std_logic_vector(2 downto 0);  -- load use (the destination)
	
	MemRead1 : in std_logic;  -- memRead in decodeExecuteBuffer
	MemRead2 : in std_logic;  -- memRead in mem1mem2Buffer
	memWrite1,memWrite2: in std_logic;
	Rs : in std_logic_vector(2 downto 0);  --sources
	Rt : in std_logic_vector(2 downto 0);  --sources
	FETCHDEC_MemRead,FETCHDEC_MemWrite: in std_logic;
	flush: out std_logic ;
	PCSrcControlSignal: in std_logic_vector(1 downto 0);
	clearBuffer: out std_logic;
	branch_signal : in std_logic
		
	);
	end component;
	
	
	component HDUSrcesBuffer is
	port(clk: in std_logic;
		SrcsIn: in std_logic_vector(1 downto 0);
		SrcsOut : out std_logic_vector(1 downto 0)
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
		 IDEXE_SrcRd:in std_logic_vector(2 downto 0);
		 ioWriteOut:in std_logic;
		 FUsignal:out std_logic_vector(1 downto 0);
		 SrcsHDU: in std_logic
		 );
	end component;
	
	component mux_2x1 IS 
	Generic ( n : Integer:=16);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
	end component mux_2x1;
	
	component mux8x1 IS 
	Generic ( n : Integer:=16);
	PORT ( in0,in1,in2,in3,in4,in5,in6,in7 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (2 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
	END component;
	
	
	signal ExecuteResultOut :  std_logic_vector(15 downto 0);
	signal regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,ioWriteOut,SPStatusOut,regWrite :  std_logic;
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
	
	signal IDEXE_SrcRs,IDEXE_SrcRt,IDEXE_SrcRd,FETCHDEC_SrcRs,FETCHDEC_SrcRt: std_logic_vector(2 downto 0);
	
	signal MEM1MEM2Result:  std_logic_vector (15 downto 0);
	
	signal MEM1MEM2_Rd: std_logic_vector (2 downto 0);
	signal MEM1MEM2_RegWrite : std_logic;
	
	signal EXEMEM1_Rd: std_logic_vector (2 downto 0);
	signal EXEMEM1_RegWrite : std_logic;
	
	signal programCounter:  std_logic_vector(15  downto 0);
	signal addressComing:  std_logic_vector(15  downto 0);
	signal interruptSignal :  std_logic:= '0';
	
	
	signal rsSelector,rtSelector :  std_logic_vector (1 downto 0);
	Signal zeros: std_logic_vector (15 downto 0);
	
	signal PCSrcControlSignal,SrcsHDU :  std_logic_vector (1 downto 0);
	signal nextAddressSelector : std_logic_vector (2 downto 0);
	signal nextAddressSelector2 : std_logic_vector (2 downto 0);
	signal memRead1 : std_logic;
	signal memRead2 : std_logic;
	signal memWrite1: std_logic;
	signal memWrite2: std_logic;
	
	
	signal FETCHDEC_MemRead :  std_logic;
	signal FETCHDEC_MemWrite :  std_logic;
	
	signal  ONE: std_logic_vector (15 downto 0) := (others=>'0'); -- will be edited in the begin section
	signal memWriteHDU: std_logic;
	
	signal  TWO: std_logic_vector (15 downto 0) := (others=>'0'); --will be edited in the begin section
	signal cin : std_logic := '0';
	signal ProgramCounterPlusOne : std_logic_vector (15 downto 0);
	signal ProgramCounterPlusTwo : std_logic_vector (15 downto 0);
   signal clearBuffer : std_logic;
	signal	 branch_signal :  std_logic;
	 signal jumpAddress : std_logic_vector(15 downto 0);
	 
	 signal SrcsNeeded : std_logic_vector(1 downto 0);
begin
	ONE (0) <= '1';
	TWO(1 downto 0) <= "10";
	nextAddressSelector <= '0' & PCSrcControlSignal;
	-- execute result out holds the value from exemem buffer
	fde : FetchDecodeExecuteIntegration port map (clk,rst,flush,clearBuffer,regWrite,destVal,destAddress,
	ExecuteResultOut,regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusout,ioWriteOut,
	PCSrcOut,BrTypeOut,SrcsHDU,flagReg,rdTemp1,src2Propagate,IDEXE_SrcRs,IDEXE_SrcRt,IDEXE_SrcRd,FETCHDEC_SrcRs,
	FETCHDEC_SrcRt,FETCHDEC_MemRead,FETCHDEC_MemWrite,RsSelector,RtSelector,mem1MEM2Result
	,programCounter,addressComing,interrupt,PCSrcControlSignal,memRead1,memWriteHDU,branch_signal,jumpAddress);
	--added ioWriteOut ky
	--outPort<=ExecuteResultOut; --ky
	
	memWrite1<= memWriteHDU;
	memWrite2<= memWriteOut;
	
	--memwrite fetchDecode
	zeros<=(others=>'0');--ky
	memRead2 <= memReadOut;
	
	
	adding1 : full_adder generic map(16) port map (ProgramCounter,ONE,cin,ProgramCounterPlusOne);
	adding2: full_adder generic map(16) port map (ProgramCounter,TWO,cin,ProgramCounterPlusTwo);
	
	--mux to choose outport when iowrite is 1 ky
	my_mux2x1: mux_2x1 port map(zeros,ExecuteResultOut,ioWriteOut,outPort);--ky
	 
	 -- note : destval is memwb value
	EXEMEM1_Rd <= rdTemp1;
	EXEMEM1_RegWrite <= regWriteOut;
	 
	mmwb : memoryAndWriteBackIntegration port map (clk,rst,memReadOut,memWriteOut,SPEnOut,
	SPStatusOut,RegInSrcOut,regWriteOut,
	ExecuteResultOut,src2Propagate,rdTemp1,destAddress,regWrite,destVal,MEM1MEM2_Rd,MEM1MEM2_RegWrite,MEM1MEM2Result);
	
	HDUInst : HDU port map (EXEMEM1_Rd,IDEXE_SrcRd,MEMRead1,MEMRead2,memWrite1,memWrite2
	,FETCHDEC_SrcRs,FETCHDEC_SrcRt,FETCHDEC_MemRead,FETCHDEC_MemWrite,flush,PCSrcControlSignal,clearBuffer,branch_signal);
	
	FUSrc_1 : forwardingUnit port map ( MEM1MEM2_Rd,MEM1MEM2_RegWrite, 
			 EXEMEM1_RegWrite,EXEMEM1_Rd,destAddress,regWrite,IDEXE_SrcRs,IDEXE_SrcRd,ioWriteOut,RsSelector,SrcsNeeded(1));
--			 
	FUSrc_2 : forwardingUnit port map ( MEM1MEM2_Rd,MEM1MEM2_RegWrite, 
			 EXEMEM1_RegWrite,EXEMEM1_Rd,destAddress,regWrite,IDEXE_SrcRt,IDEXE_SrcRd,ioWriteOut,RtSelector,SrcsNeeded(0));
	
	bufferingSrcs: HDUSrcesBuffer port map(clk,SrcsHDU,SrcsNeeded);
	
	muxPC: mux8x1 port map(ProgramCounterPlusOne,ProgramCounterPlusOne,ProgramCounter,programCounter,programCounter,
	programCounter,programCounter,jumpAddress,nextAddressSelector2,addressComing);
	
	
	nextAddressSelector2 <= "111" when branch_signal = '1'
	else nextAddressSelector when flush = '0'
	else "010";
	
	
	
	
	--flush the buffer
end integraaaate;


