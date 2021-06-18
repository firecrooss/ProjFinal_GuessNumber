library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity attemptcalc is
port(clk			: in std_logic;
	  reset		: in std_logic;
	  random		: in std_logic_vector(6 downto 0);
	  result		: in std_logic_vector(1 downto 0);
	  attempt	: out std_logic_vector(6 downto 0);
	  cheater	: out std_logic);
	  
end attemptcalc;

architecture Behavioral of attemptcalc is

signal s_hi : unsigned(6 downto 0) := "1100011";
signal s_lo : unsigned(6 downto 0) := "0000000";

begin
	
process(clk, random)
begin
	if(reset = '1') then
		
		s_hi <= "1100011";
		s_lo <= "0000000";
		
	else
		
		cheater <= '0';
		
		if(s_lo > s_hi) then
			cheater <= '1';
		else
		
		if(unsigned(random) >= s_lo and unsigned(random) <= s_hi) then
		
			attempt <= random;
			
		if(result = "01") then --lo
			s_lo <= unsigned(random) + 1;
		end if;
		if(result = "10") then --hi
			s_hi <= unsigned(random) - 1;
		end if;
		
		end if;
		end if;
	end if;
	
end process;
	
end Behavioral;