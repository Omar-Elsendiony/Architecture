library IEEE,std;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity integratePC_IC_FDB is
	generic (addressableSpace : integer:= 10 ; wordSize: integer:= 16);
	port(clk,rst,flush: in std_logic;
		clearBuffer : in std_logic;
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
end entity;

Architecture implementInt of integratePC_IC_FDB is

component fetchDecodeBuffer is
	generic (wordSize: integer:= 16 ; addressableSpace: integer:= 10);
	port(clk,flush,clearBuffer: in std_logic;
		incrementedPC: in std_logic_vector(wordSize - 1 downto 0);
		instructionIn: in std_logic_vector((wordSize*2) -1 downto 0);
		opCode : out std_logic_vector(4 downto 0);
		rs,rt,rd : out std_logic_vector(2 downto 0);
		immediateVal : out std_logic_vector(wordSize - 1 downto 0);
		incPC : out std_logic_vector(wordSize - 1 downto 0));
end component;

component mux_2x1 IS 
	Generic ( n : Integer:=16);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END component;

component mux IS 
	Generic ( n : Integer:=16);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END component;


component pc is
port (clk,rst:in std_logic;
		nextAddress : in std_logic_vector(15 downto 0);
		instructionAddress: out std_logic_vector(15 downto 0);
		incrementedPC : out std_logic_vector(15 downto 0);
		firstLocation : in std_logic_vector(15 downto 0)
);
end component;

component instructionCache is
	generic (addressableSpace : integer:= 16 ; wordSize: integer:= 16);
	port(interrupt,clk: in std_logic;
		instructionAddress: in std_logic_vector(addressableSpace - 1 downto 0);
		instruction: out std_logic_vector((wordSize*2)-1 downto 0);
		ISR : out std_logic_vector(wordSize - 1 downto 0);
		firstLocation : out std_logic_vector(addressableSpace - 1 downto 0));  --intitialize memory
		--initialMemory
end component;

signal nAddress,iAddress,ipc,ISR,firstLocation:std_logic_vector(15 downto 0); -- inputs/outputs for pc and icasche
signal interrupt: std_logic := '0';  -- interrupt signal that if present loads the pc with the address in m[1]
signal instr,instrBuff : std_logic_vector(wordSize*2 - 1 downto 0);
signal tempSelector: std_logic_vector(1 downto 0);
begin
programC: pc port map (clk,rst,nAddress,iAddress,ipc,firstLocation);
icache :instructionCache port map(interruptSignal,clk,iAddress,instr,ISR,firstLocation);
currentPC <= iAddress;
tempSelector <= '0' & interruptSignal;
muxy: mux port map (addressComing,ISR,addressComing,addressComing,tempSelector,nAddress);

fd :fetchDecodeBuffer port map (clk,flush,clearBuffer,ipc,instrBuff,opCode,rs,rt,rd,immediateVal,incPC);

instrBuff <= (others=>'0') when clearBuffer = '1'
else instr;


end architecture;