library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity IExeMem is port
(
	clk: in std_logic;
	ExecuteResult: in std_logic_vector(15 downto 0);
	FlagRegResult:in std_logic_vector(2 downto 0);
	regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,ioWrite : in std_logic;--added ky
	PCSrc,BrType: in std_logic_vector(1 downto 0);
	rdIn : in std_logic_vector (2 downto 0);
	ExecuteResultOut : out std_logic_vector(15 downto 0);
	regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut,ioWriteOut : out std_logic;--added ky
	PCSrcOut,BrTypeOut: out std_logic_vector(1 downto 0);
	FlagRegResultOut:out std_logic_vector(2 downto 0);
	rdOut : out std_logic_vector (2 downto 0);
	src2In : in std_logic_vector(15 downto 0);
	src2Out : out std_logic_vector(15 downto 0)
);
end entity;

architecture myIExeMem of IExeMem is

begin
	process(clk)
	begin
	IF (RISING_EDGE(clk)) then
		ExecuteResultOut<=ExecuteResult;
		regWriteOut <= regWrite;
		memWriteOut<=memWrite;
		memReadOut<=memRead;
		RegInSrcOut<=RegInSrc;
		SPEnOut<=SPEn;
		SPStatusOut<=SPStatus;
		PCSrcOut<=PCSrc;
		BrTypeOut<=BrType;
		FlagRegResultOut<=FlagRegResult;
		rdOut <= rdIn;
		src2Out <= src2In;
		ioWriteOut<=ioWrite;
	end if;


	end process;
	
end myIExeMem;