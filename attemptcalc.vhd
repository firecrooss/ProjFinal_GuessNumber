library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity attemptcalc is
port(clk			: in std_logic;
	  enable		: in std_logic;
	  reset		: in std_logic;
	  dataIn		: in std_logic_vector(1 downto 0);
	  attempt	: out std_logic_vector(6 downto 0);
	  cheater	: out std_logic);
end attemptcalc;

architecture Behavioral of attemptcalc is

signal s_hi, s_lo, s_middle : unsigned(6 downto 0);

begin
	
process(clk)
begin
	if(reset = '1') then
		
		s_hi <= "1100011";
		s_lo <= "0000000";
		
	else
		
		if(s_lo > s_hi) then
			cheater <= '1';
		end if;
		
		if(enable = '1') then		
			
			s_middle <= (s_lo + s_hi + 1)/ 2;
			attempt <= std_logic_vector(s_middle);
			
			if(dataIn = "01") then --lo
				s_lo <= s_middle + 1;
			end if;
			if(dataIn = "10") then --hi
				s_hi <= s_middle - 1;
			end if;
		end if;
	end if;
	
end process;
	
end Behavioral;