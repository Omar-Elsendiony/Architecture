library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity ExcuteStage is port
(
	rst,clk:in std_logic;
	src1: in std_logic_vector(15 downto 0);
	src2: in std_logic_vector(15 downto 0);
	ALUFn: in std_logic_vector(3 downto 0);
	ALUResult: out std_logic_vector(15 downto 0);
	FlagRegOut:out std_logic_vector(2 downto 0)  
);
end entity;

architecture myExcuteStage of ExcuteStage is
	component ALU is port
	(	
		FlagRegIn: in std_logic_vector (2 downto 0);
		A: in std_logic_vector(15 downto 0);
		B: in std_logic_vector(15 downto 0);
		SEL: in std_logic_vector(3 downto 0);
		Result: out std_logic_vector(15 downto 0);
		FlagRegOut:out std_logic_vector(2 downto 0)  
	);
	end component;
	component CCR IS PORT
	(	rst,clk : IN std_logic; 
		inFlag:in std_logic_vector(2 downto 0);
		outFlag : OUT std_logic_vector(2 downto 0)
	);
	END component;
	
	
	signal FlagRegInAlu: std_logic_vector(2 downto 0);
	signal FlagRegoutAlu: std_logic_vector(2 downto 0);
begin
	ALUinst: ALU port map (FlagRegInAlu,src1,src2,ALUFn,ALUResult,FlagRegoutAlu);
	CCRinst: CCR port map (rst,clk,FlagRegoutAlu,FlagRegInAlu);
	FlagRegOut<= FlagRegoutAlu;
	
	
end myExcuteStage;