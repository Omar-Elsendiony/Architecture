library IEEE,std;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity memoryAndWriteBackIntegration is
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
			 EXEMEM1_RegWrite:out std_logic;  -- reg write in buffer
			 EXEMEM1_Rd:out std_logic_vector(2 downto 0);
			 WB_Rd:out std_logic_vector(2 downto 0);
			 WB_RegWrite:out std_logic;
			 MemRead1 : out std_logic;  -- memRead in ExecuteMEMBuffer that enters HDU
			 MemRead2 : out std_logic  -- memRead in MEM1MEM2Buffer that enters HDU
		);
end entity;

Architecture implementMWB of memoryAndWriteBackIntegration is

component mux_2x1 IS 
	Generic ( n : Integer:=16);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END component;

component Data_Memory IS generic (n:integer:=16);
PORT (clk,rst : IN std_logic;
memread,memwrite : IN std_logic;
address : IN std_logic_vector(9 DOWNTO 0);
memwritedata: IN std_logic_vector(n-1 DOWNTO 0);
dataout : OUT std_logic_vector(n-1 DOWNTO 0) 
);
END Component ;

component WBbuffer IS GENERIC (n:integer:=16;m:integer:=3);
port 
(clk,rst:in std_logic;
WB_destinationaddress: in std_logic_vector (m-1 downto 0);
RegWrite,RegInSrc: in std_logic;
WB_Aluresultin,WB_Memoryoutputin: in std_logic_vector (n-1 downto 0);
WB_destinationaddressout: out std_logic_vector (m-1 downto 0);
WB_Aluresultout,WB_Memoryoutputout: out std_logic_vector (n-1 downto 0);
RegWriteout,RegInSrcout: out std_logic );
end component;

component MEM1MEM2Buffer is
	generic (wordSize: integer:= 16 ; addressableSpace: integer:= 10);
	port(clk: in std_logic;
		RegInSrcIn,RegWriteIn,MemReadIn: in std_logic;
		rdIn : in std_logic_vector(2 downto 0);
		memValIn : in std_logic_vector(15 downto 0);
		ALUResultIn : in std_logic_vector(15 downto 0);
		RegInSrcOut,RegWriteOut,MemReadOut: out std_logic;
		rdOut : out std_logic_vector(2 downto 0);
		memValOut : out std_logic_vector(15 downto 0);
	   ALUResultOut: out std_logic_vector(15 downto 0)
		);
end component;

component stackRegister IS generic (n:integer:=16);
PORT (clk,rst : IN std_logic;
spEn,spStatus : IN std_logic;
spAddress : out std_logic_vector(n-1 DOWNTO 0)
);
END component;

component Data_Memory_2 IS generic (n:integer:=16);
PORT (clk:in std_logic;
	memValIn : in std_logic_vector(15 downto 0);
	memValOut : out std_logic_vector(15 downto 0)
);
end component;

signal WB_Aluresultout,WB_Memoryoutputout,spAddress: std_logic_vector (15 downto 0);
signal addressIntoMem,memVal,memVal2,memVal3,memVal4,ALUResult1,ALUResult2,ALUResult3: std_logic_vector(15 downto 0);
signal RegInSrcTemp,RegWriteTemp,MemReadTemp:  std_logic;
signal rdTemp,rdWB: std_logic_vector(2 downto 0);
signal regInSrcOO: std_logic;
begin
DM : data_Memory port map (clk,rst,memRead,memWrite,addressIntoMem(9 downto 0),rtOrPC,memVal);
writeBackBuffer : WBbuffer port map (clk,rst,rdTemp,RegWriteTemp,regInSrcTemp,ALUResult2,memVal3,regDst,ALUResult3,memVal4
,regWriteOutOfintegration,regInSrcOO);
SR : stackRegister port map (clk,rst,spEn,spStatus,spAddress);
addressMux : mux_2x1 port map (ALUResult,spAddress,spEn,addressIntoMem);
mem12Buffer : mem1MEM2Buffer PORT MAP (clk,RegInSrc,RegWrite,MemRead,rd,memVal,ALUResult,
RegInSrcTemp,RegWriteTemp,MemReadTemp,rdTemp,memVal2,ALUResult2);
DM2 : Data_Memory_2 port map (clk,memVal2,memVal3);

aluORMemory : mux_2x1 port map (memVal4,ALUResult3,regInSrcOO,regDstValue);


end architecture;