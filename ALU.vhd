library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mine.all;

entity ALU is port
(
	FlagRegIn: in std_logic_vector (2 downto 0);
	A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	SEL: in std_logic_vector(3 downto 0);
	Result: out std_logic_vector(15 downto 0);
	FlagRegOut:out std_logic_vector(2 downto 0)  
);
end entity;

architecture ALUArch of ALU is
	
begin
	process(A,B,SEL,FlagRegIn)
	variable flagTemp: std_logic_vector(2 downto 0):="000";
	variable resultSignal : std_logic_vector(15 downto 0):=x"0000";
	variable ResultTemp: std_logic_vector(16 downto 0):="00000000000000000";
	begin

		if(SEL = "1010") then  --SETC
			flagTemp(carryFlag):='1';
			flagTemp(zeroFlag):=FlagRegIn(zeroFlag);
			flagTemp(negativeFlag):=FlagRegIn(negativeFlag);
			
		elsif(SEL ="1011") then --CLRC
			flagTemp(carryFlag):='0';
			flagTemp(zeroFlag):=FlagRegIn(zeroFlag);
			flagTemp(negativeFlag):=FlagRegIn(negativeFlag);
	
		elsif(SEL = "0111") then --NOT 
		
			Result<= NOT A;
			--update flags
			flagTemp(carryFlag):=FlagRegIn(carryFlag);
			flagTemp(zeroFlag):=FlagRegIn(zeroFlag);
			flagTemp(negativeFlag):=FlagRegIn(negativeFlag);
			

		elsif(SEL = "1001") then --NOP   TODO phase 1 done
			Result<=(others=>'0');
			--update flags
			flagTemp(carryFlag):=FlagRegIn(carryFlag);
			flagTemp(zeroFlag):=FlagRegIn(zeroFlag);
			flagTemp(negativeFlag):=FlagRegIn(negativeFlag);
			FlagRegOut<=flagTemp;
			

		elsif(SEL = "0001") then --ADD OR IADD
			ResultTemp:= std_logic_vector(unsigned('0'& A) + unsigned('0'&B));
			if(ResultTemp(16) = '1') then
				Result<= ResultTemp(15 downto 0);
				flagTemp(carryFlag) := ResultTemp(16);
			else 
				Result<= ResultTemp(15 downto 0);
				flagTemp(carryFlag) := '0';
			end if;

		elsif(SEL = "0010") then --SUB
			ResultTemp:= std_logic_vector(unsigned('0'&A) - unsigned('0'&B));
			if(to_integer(unsigned(ResultTemp)) = 0) then
				Result<=(others=>'0'); 
				flagTemp(zeroFlag):='1';
			else
				Result<= ResultTemp(15 downto 0);
				flagTemp(zeroFlag):='0';
			end if;

		 elsif(SEL = "0101") then --AND   TODO phase 1 done
			resultSignal:= A And B;
			Result<=A And B;
			--update flags 
			flagTemp(carryFlag):=FlagRegIn(carryFlag);--dont change cf
			if (resultSignal=x"0000") then
				--zf = 1
				flagTemp(zeroFlag):='1';
			else
				--zf = 0
				flagTemp(zeroFlag):='0';
			end if;
			if (resultSignal(15)='1')then
				--NF = 1
				flagTemp(negativeFlag):='1';
			else 
				--NF = 0
				flagTemp(negativeFlag):='0';
			end if;
			

		elsif(SEL = "0100") then --OR
			Result<= A OR B;

		elsif(SEL = "0000") then --INC TODO phase 1   --not complete carry flag
			resultSignal:= std_logic_vector(signed(A) +1);
			Result<=std_logic_vector(signed(A) +1);
			--update flags 
			ResultTemp:= std_logic_vector(unsigned('0'& A) + 1);
			if(ResultTemp(16) = '1') then
				--Result<= ResultTemp(15 downto 0);
				flagTemp(carryFlag) := ResultTemp(16);
			else 
				--Result<= ResultTemp(15 downto 0);
				flagTemp(carryFlag) := '0';
			end if;
			if (resultSignal=x"0000") then
				--zf = 1
				flagTemp(zeroFlag):='1';
			else
				--zf = 0
				flagTemp(zeroFlag):='0';
			end if;
			if (resultSignal(15)='1')then
				--NF = 1
				flagTemp(negativeFlag):='1';
			else 
				--NF = 0
				flagTemp(negativeFlag):='0';
			end if;

		elsif(SEL = "0011") then --DEC
			Result<= std_logic_vector(unsigned(A) -1);
			
		elsif(SEL = "0110") then --IN,LDD,STD (Func=> Result=Src1)   TODO phase 1 done 
			Result<= std_logic_vector(unsigned(A));
			--Do Not change flags
			flagTemp(carryFlag):=FlagRegIn(carryFlag);
			flagTemp(zeroFlag):=FlagRegIn(zeroFlag);
			flagTemp(negativeFlag):=FlagRegIn(negativeFlag);
			FlagRegOut<=flagTemp;
		else 
			flagTemp(carryFlag):=FlagRegIn(carryFlag);
			flagTemp(zeroFlag):=FlagRegIn(zeroFlag);
			flagTemp(negativeFlag):=FlagRegIn(negativeFlag);
			FlagRegOut<=flagTemp;
			Result<=(others=>'0');

			
		end if;
		FlagRegOut<=flagTemp;


	end process;
--	FlagRegOut<=flagTempSignal;
end ALUArch;