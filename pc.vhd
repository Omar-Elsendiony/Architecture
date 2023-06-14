library IEEE,std;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;

entity pc is
port (clk,rst:in std_logic;
		nextAddress : in std_logic_vector(15 downto 0);
		instructionAddress: out std_logic_vector(15 downto 0);
		incrementedPC : out std_logic_vector(15 downto 0);
		firstLocation : in std_logic_vector(15 downto 0)
		);
end entity;

architecture implementPC of pc is
signal counterSig : integer;

begin
process(rst,clk) is
variable counter: integer;
variable ipc : std_logic_vector(15 downto 0);
begin
	if (rst = '1') then
		counter := 0;
		instructionAddress <= "0000000000000000";
		--incrementedPC <= "0000000000000000";
	elsif (rising_edge(clk)) then
		counter := to_integer(unsigned(nextAddress)) ;
		counter := counter + 1;
		ipc := std_logic_vector(to_unsigned(counter,incrementedPC'length));	
			instructionAddress <= nextAddress;
	counterSig <= counter;
	incrementedPC <= ipc;
	end if;

end process;

end implementPC;