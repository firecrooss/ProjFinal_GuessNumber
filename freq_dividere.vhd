library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity freq_dividere is
	generic(divFactor1 : natural := 50000000;
	        divFactor2 : natural := 25000000;
			  divFactor4 : natural := 12500000;
			  divFactor8 : natural := 6250000);
	port(clkIn	: in  std_logic;
		  c1Hz : out std_logic;
		  c2Hz : out std_logic;
		  c4Hz : out std_logic;	
		  c8Hz : out std_logic);
end freq_dividere;

architecture RTL of freq_dividere is

	signal s_divCounter1, s_divCounter2, s_divCounter4, s_divCounter8 : natural;

begin
	process(clkIn)
	begin
		if (rising_edge(clkIn)) then
			if (s_divCounter1 = divFactor1 - 1) then
				c1Hz		 <= '0';
				s_divCounter1 <= 0;
			else
				if (s_divCounter1 = (divFactor1 / 2 - 1)) then
					c1Hz	 <= '1';
				end if;
				s_divCounter1 <= s_divCounter1 + 1;
			end if;
		end if;
		if (rising_edge(clkIn)) then
			if (s_divCounter2 = divFactor2 - 1) then
				c2Hz		 <= '0';
				s_divCounter2 <= 0;
			else
				if (s_divCounter2 = (divFactor2 / 2 - 1)) then
					c2Hz	 <= '1';
				end if;
				s_divCounter2 <= s_divCounter2 + 1;
			end if;
		end if;
		if (rising_edge(clkIn)) then
			if (s_divCounter4 = divFactor4 - 1) then
				c4Hz		 <= '0';
				s_divCounter4 <= 0;
			else
				if (s_divCounter4 = (divFactor4 / 2 - 1)) then
					c4Hz	 <= '1';
				end if;
				s_divCounter4 <= s_divCounter4 + 1;
			end if;
		end if;
		if (rising_edge(clkIn)) then
			if (s_divCounter8 = divFactor8 - 1) then
				c8Hz		 <= '0';
				s_divCounter8 <= 0;
			else
				if (s_divCounter8 = (divFactor8 / 2 - 1)) then
					c8Hz	 <= '1';
				end if;
				s_divCounter8 <= s_divCounter8 + 1;
			end if;
		end if;
	end process;
end RTL;