library IEEE;
use IEEE.std_logic_1164.all;

entity forwardingUnit is
  port (
    MEM1MEM2_Rd:in std_logic_vector(2 downto 0);
    MEM1MEM2_RegWrite:in std_logic;
    EXEMEM1_RegWrite:in std_logic;
    EXEMEM1_Rd:in std_logic_vector(2 downto 0);
    WB_Rd:in std_logic_vector(2 downto 0);
    WB_RegWrite:in std_logic;
    DECEXE_Src:in std_logic_vector(2 downto 0);
	 IDEXE_SrcRd:in std_logic_vector(2 downto 0);
	 ioWriteOut:in std_logic;
    FUsignal:out std_logic_vector(1 downto 0)
 
    );
end entity;

architecture architectur of forwardingUnit is
begin
  
  FUsignal<="01" when ((EXEMEM1_RegWrite='1' and EXEMEM1_Rd=DECEXE_Src)) 
  else "10" when ((MEM1MEM2_RegWrite='1' and MEM1MEM2_Rd=DECEXE_Src))
  else "11" when ( (WB_RegWrite='1' and WB_rd=DECEXE_Src))
  else "00";


end architectur;
   
    
    
