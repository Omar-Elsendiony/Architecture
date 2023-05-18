library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity HDU is port
(
	EXEMEMDst : in std_logic_vector(2 downto 0);
	IDEXEDst : in std_logic_vector(2 downto 0);
	MemRead1 : in std_logic;  -- memRead in decodeExecuteBuffer
	MemRead2 : in std_logic;  -- memRead in mem1mem2Buffer
	
	Rs : in std_logic_vector(2 downto 0);
	Rt : in std_logic_vector(2 downto 0);
	flush: out std_logic 
	
);
end entity;

architecture integraaaate of HDU is

	
	
begin
	flush <= '1' when ((Rs = EXEMEMDst or Rt = EXEMEMDst) and mEMRead1='1') or ((RS = IDEXEDst or Rt = IDEXEDst) and  mEMRead2 = '1')
	else '0';
	
	
	--flush the buffer
end integraaaate;


