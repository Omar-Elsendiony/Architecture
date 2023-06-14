library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity HDU is port
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
end entity;

architecture integraaaate of HDU is
signal flushTemp1,flushTemp2 :  std_logic;


begin
	flush <= '1' when ((Rs = EXEMEMDst or Rt = EXEMEMDst) and mEMRead1='1') or 
	((RS = IDEXEDst or Rt = IDEXEDst) and  mEMRead2 = '1') or Branch_signal='1'
	else '0';
	
	clearBuffer <= '1' when PCSrcControlSignal = "01" or Branch_signal = '1'
	else '0';
	
	flushTemp2 <= '1' when ((memRead1 = '1' or memWrite1= '1') and (FETCHDEC_MemRead = '1' or FETCHDEC_MemWrite = '1'))
	else '0';
	
	
	
	--flush <= flushTemp1 or flushTemp2;
	
	--flush the buffer
end integraaaate;


