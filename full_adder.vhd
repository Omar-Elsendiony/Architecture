LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


entity full_adder is
    generic (
        WIDTH : positive := 8
    );
    port (
        A : in std_logic_vector(WIDTH - 1 downto 0);
        B : in std_logic_vector(WIDTH - 1 downto 0);
        Cin : in std_logic;
        S : out std_logic_vector(WIDTH - 1 downto 0);
        Cout : out std_logic
    );
end entity;

architecture Behavioral of full_adder is
    signal C : std_logic_vector(WIDTH downto 0);
begin
    C(0) <= Cin;
    FA: for i in 0 to WIDTH - 1 generate
        S(i) <= A(i) xor B(i) xor C(i);
        C(i + 1) <= (A(i) and B(i)) or (A(i) and C(i)) or (B(i) and C(i));
    end generate FA;
    Cout <= C(WIDTH);
end architecture Behavioral;