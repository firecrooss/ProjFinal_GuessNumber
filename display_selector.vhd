library IEEE;
use IEEE.std_logic_1164.all;

entity display_selector is
	 port(d7			: in std_logic_vector(3 downto 0);
			d6			: in std_logic_vector(3 downto 0);
			d5			: in std_logic_vector(3 downto 0);
			d4			: in std_logic_vector(3 downto 0);
			selector	: in std_logic;
			enable	: in std_logic_vector(2 downto 0);
			txt		: in std_logic_vector(39 downto 0);
			bin7		: out std_logic_vector(4 downto 0);
			enable7	: out std_logic;
			bin6		: out std_logic_vector(4 downto 0);
			enable6	: out std_logic;
			bin5		: out std_logic_vector(4 downto 0);
			enable5	: out std_logic;
			bin4		: out std_logic_vector(4 downto 0);
			enable4	: out std_logic;
			bin3		: out std_logic_vector(4 downto 0);
			enable3	: out std_logic;
			bin2		: out std_logic_vector(4 downto 0);
			enable2	: out std_logic;
			bin1		: out std_logic_vector(4 downto 0);
			enable1	: out std_logic;
			bin0		: out std_logic_vector(4 downto 0);
			enable0	: out std_logic);
end display_selector;

architecture Behavioral of display_selector is

begin
process(selector, enable, txt, d7, d6, d5, d4)
begin
	if(selector = '1') then
		bin7 <= txt(39 downto 35);
		bin6 <= txt(34 downto 30);
		bin5 <= txt(29 downto 25);
		bin4 <= txt(24 downto 20);
		bin3 <= txt(19 downto 15);
		bin2 <= txt(14 downto 10);
		bin1 <= txt(9 downto 5);
		bin0 <= txt(4 downto 0);
		
		enable7 <= enable(0);
		enable6 <= enable(0);
		enable5 <= enable(0);
		enable4 <= enable(0);
		enable3 <= enable(0);
		enable2 <= enable(0);
		enable1 <= enable(0);
		enable0 <= enable(0);
		
	else
		bin7 <= '0' & d7;
		bin6 <= '0' & d6;
		
		bin5 <= '0' & d5;
		bin4 <= '0' & d4;
		
		bin3 <= txt(19 downto 15);
		bin2 <= txt(14 downto 10);
		bin1 <= txt(9 downto 5);
		bin0 <= txt(4 downto 0);
		
		enable7 <= enable(2);
		enable6 <= enable(2);
		
		enable5 <= enable(1);
		enable4 <= enable(1);
		
		enable3 <= enable(0);
		enable2 <= enable(0);
		enable1 <= enable(0);
		enable0 <= enable(0);
		
	end if;
end process;
end Behavioral;