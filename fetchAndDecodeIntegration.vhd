library IEEE,std;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity fetchAndDecodeIntegration is
	generic (addressableSpace : integer:= 10 ; wordSize: integer:= 16);
	port(clk,rst,flush: in std_logic;
		src1,src2 : out std_logic_vector(15 downto 0);
		regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,ioWrite : OUT std_logic; --added iOwrite ky
		PCSrc,BrType: out std_logic_vector(1 downto 0);
		ALUFn : out std_logic_vector (3 downto 0);
		regWriteWB: in std_logic;
		destVal : in std_logic_vector(15 downto 0);
		destAddress: in std_logic_vector(2 downto 0);
		rdOut: out std_logic_vector(2 downto 0);
				---------------- Needed -------------------------
--		rsOut : out std_logic_vector(2 downto 0);  -- for hazard detection unit 
--		rtOut : out std_logic_vector(2 downto 0);  -- for hazard detection unit
		
		FETCHDEC_SrcRs : out std_logic_vector(2 downto 0); -- Rs that enters HDU from fetch/decode buffer 
	   FETCHDEC_SrcRt : out std_logic_vector(2 downto 0); -- Rt that enters HDU from fetch/decode buffer 
	 	programCounter : out std_logic_vector(15 downto 0); -- program counter before incrementing
		 
		addressComing: in std_logic_vector(wordSize - 1  downto 0);
		interruptSignal : in std_logic;
		 
		rSS: out std_logic_vector (2 downto 0);
		rtt: out std_logic_vector (2 downto 0)	
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
		immediateVal: out std_logic_vector((wordSize)-1 downto 0);
		currentPC: out std_logic_vector(wordSize - 1 downto 0);
		addressComing: in std_logic_vector(wordSize - 1  downto 0);
		interruptSignal : in std_logic
		);
end component;


component integrateDecodeStage is
	generic (addressableSpace : integer:= 10 ; wordSize: integer:= 16);
	port(clk,rst,flush: in std_logic;
		--instructionAddress: in std_logic_vector(wordSize - 1 downto 0);
		opCode: in std_logic_vector(4 downto 0);
		rs: in std_logic_vector (2 downto 0);
		rt: in std_logic_vector (2 downto 0);
		rd: in std_logic_vector (2 downto 0);
		incPC: in std_logic_vector(15 downto 0);
		immediateVal: in std_logic_vector((wordSize)-1 downto 0);
		src1,src2 : out std_logic_vector(15 downto 0);
		regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,ioWriteOut : OUT std_logic;--added ioWriteOut   ky
		PCSrc,BrType: out std_logic_vector(1 downto 0);
		ALUFn : out std_logic_vector (3 downto 0);
		regWriteWB: in std_logic;
		destVal : in std_logic_vector(15 downto 0);
		destAddress: in std_logic_vector(2 downto 0);
		rdOut : out std_logic_vector (2 downto 0);
		rSS: out std_logic_vector (2 downto 0);
		rtt: out std_logic_vector (2 downto 0)		
		);
end component;

signal opCode: std_logic_vector(4 downto 0);
signal rs,rt,rd : std_logic_vector(2 downto 0);
signal incPC,immediateVal:std_logic_vector(15 downto 0);
signal ioWriteSig:std_logic;

--src1,src2,regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,PCSrc,BrType,ALUFn,regWriteWB,destVal,destAddress


begin

fetch : integratePC_IC_FDB port map (clk,rst,opCode,rs,rt,rd,incPC,immediateVal,programCounter,addressComing,interruptSignal);
decode : integrateDecodeStage port map (clk,rst,flush,opCode,rs,rt,rd,incPC,immediateVal,
src1,src2,regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,ioWriteSig,PCSrc,BrType,ALUFn,regWriteWB,
destVal,destAddress,rdOut,rSS,rtt);

FETCHDEC_SrcRs <= rs;
FETCHDEC_SrcRt <= rt;


ioWrite<=ioWriteSig;--added ky

end architecture;