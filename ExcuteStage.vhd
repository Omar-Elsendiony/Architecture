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
	FlagRegOut:out std_logic_vector(2 downto 0);
	EXEMEMResult : in std_logic_vector(15 downto 0); --forward
	MEM1MEM2Result : in std_logic_vector(15 downto 0);  --forward
	MEMWBResult :  in std_logic_vector(15 downto 0);  --forward
	RsSelector : in std_logic_vector(1 downto 0);  --FORWAAAAAAAAAAAAAAAAAAAARD
	RtSelector : in std_logic_vector(1 downto 0);  --FORWAAAAAAAAAAAAAAAAAAAARD
	BrType : in std_logic_vector(1 downto 0);
	BrOutput: out std_logic; -- the output of the branching
	rtAfterFU:out std_logic_vector(15 downto 0);
	jumpAddress : out std_logic_vector(15 downto 0)
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
	
	component mux IS 
	Generic ( n : Integer:=16);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
	END component;
	
	signal FlagRegInAlu: std_logic_vector(2 downto 0);
	signal FlagRegoutAlu: std_logic_vector(2 downto 0);   -- carry flag = 1   neg flag = 2  zero flag = 0
	signal SRCALU1,SRCALU2 : std_logic_vector(15 downto 0);
	
	signal rsEnterALU : std_logic_vector(15 downto 0);
	signal rtEnterALU : std_logic_vector(15 downto 0);
begin

	ALUinst: ALU port map (FlagRegInAlu,rsEnterALU,rtEnterALU,ALUFn,ALUResult,FlagRegoutAlu);
	CCRinst: CCR port map (rst,clk,FlagRegoutAlu,FlagRegInAlu);
	FlagRegOut<= FlagRegoutAlu;
	
	
	muxForwardSrc1 : mux port map (src1,EXEMEMResult,MEM1MEM2Result,MEMWBResult,RsSelector,rsEnterALU);
	muxForwardSrc2 : mux port map (src2,EXEMEMResult,MEM1MEM2Result,MEMWBResult,RtSelector,rtEnterALU);
	jumpAddress <= rsEnterALU;
	rtAfterFU<=rtEnterALU;
	
	BrOutput <= '1' when ((BrType = "01" and FlagRegoutAlu(0) = '1') or (BrType = "10" and FlagRegoutAlu(1) = '1') or BrType="11")
	else '0';
	
	
end myExcuteStage;