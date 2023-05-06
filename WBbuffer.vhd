LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY WBbuffer IS GENERIC (n:integer:=16;m:integer:=3);
port 
(clk,rst:in std_logic;
WB_destinationaddress: in std_logic_vector (m-1 downto 0);
RegWrite,RegInSrc: in std_logic;
WB_Aluresultin,WB_Memoryoutputin: in std_logic_vector (n-1 downto 0);
WB_destinationaddressout: out std_logic_vector (m-1 downto 0);
WB_Aluresultout,WB_Memoryoutputout: out std_logic_vector (n-1 downto 0);
RegWriteout,RegInSrcout: out std_logic );
end entity;

architecture Memory_Buffer of WBbuffer  is
begin
process(clk,rst,WB_Memoryoutputin)
begin
IF (rst='1')THEN
	WB_destinationaddressout<=(others=>'0');
	WB_Aluresultout<=(others=>'0');
	WB_Memoryoutputout<=(others=>'0');
	RegWriteout<='0';
	RegInSrcout<='0';
ELSIF rising_edge(clk) THEN
	WB_destinationaddressout<=WB_destinationaddress;
	RegWriteout<=RegWrite;
	WB_Aluresultout<=WB_Aluresultin;
	RegInSrcout<=RegInSrc;
	WB_Memoryoutputout<=WB_Memoryoutputin;	
end if;
		--WB_Memoryoutputout<=WB_Memoryoutputin;	

end process;
end Memory_Buffer;
