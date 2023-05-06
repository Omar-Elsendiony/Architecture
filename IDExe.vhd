library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity IDExe is port
(
	clk: in std_logic;
	src1,src2 : in std_logic_vector(15 downto 0);
	regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus : in std_logic;
	PCSrc,BrType: in std_logic_vector(1 downto 0);
	ALUFn : in std_logic_vector (3 downto 0);
	rdIn : in std_logic_vector (2 downto 0);
	src1Out,src2Out : out std_logic_vector(15 downto 0);
	regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut : out std_logic;
	PCSrcOut,BrTypeOut: out std_logic_vector(1 downto 0);
	ALUFnOut: out std_logic_vector (3 downto 0);
	rdOut : out std_logic_vector (2 downto 0)
);
end entity;

architecture myIDEXE of IDExe is

begin
	process(clk)
	begin
	IF (RISING_EDGE(clk)) then
		src1Out<=src1;
		src2Out<=src2;
		regWriteOut <= regWrite;
		memWriteOut<=memWrite;
		memReadOut<=memRead;
		RegInSrcOut<=RegInSrc;
		SPEnOut<=SPEn;
		SPStatusOut<=SPStatus;
		PCSrcOut<=PCSrc;
		BrTypeOut<=BrType;
		ALUFnOut<=ALUFn;
		rdOut<= rdIn;
	end if;


	end process;
	
end myIDEXE;