library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity IDExe is port
(
	clk,flush: in std_logic;
	src1,src2 : in std_logic_vector(15 downto 0);
	regWrite,memWrite,memRead,RegInSrc,SPEn,SPStatus,ioWrite : in std_logic;--added ky
	PCSrc,BrType: in std_logic_vector(1 downto 0);
	ALUFn : in std_logic_vector (3 downto 0);
	rdIn : in std_logic_vector (2 downto 0);
	src1Out,src2Out : out std_logic_vector(15 downto 0);
	regWriteOut,memWriteOut,memReadOut,RegInSrcOut,SPEnOut,SPStatusOut,ioWriteOut : out std_logic;--added ky
	PCSrcOut,BrTypeOut: out std_logic_vector(1 downto 0);
	ALUFnOut: out std_logic_vector (3 downto 0);
	rdOut : out std_logic_vector (2 downto 0);
	rsBufferIn,rtBufferIn : in std_logic_vector (2 downto 0);
	rsBufferOut,rtBufferOut : out std_logic_vector (2 downto 0)
);
end entity;

architecture myIDEXE of IDExe is

begin
	process(clk)
	
	variable counter :integer:= 0;
	begin
	IF (RISING_EDGE(clk)) then
		--if (counter = 0) then
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
		rsBufferOut <= rsBufferIn;
		rtBufferOut <= rtBufferIn;
		ioWriteOut<=ioWrite;
--		else
--		-- if control signals are zeros then the sources values are ignored
--		src1Out<=src1;
--		src2Out<=src2;
--		
--		
--		regWriteOut <= '0';
--		SPEnOut<='0';
--		SPStatusOut<='0';
--		memWriteOut<='0';
--		memReadOut<='0';
--		RegInSrcOut<='0';
--
--		PCSrcOut<="00";
--		BrTypeOut<="00";
--		ALUFnOut<="0000";
--		
--		rdOut<= rdIn;  --address of destination
--		
--		counter := counter - 1;
--		end if;
	end if;


	end process;
	
end myIDEXE;