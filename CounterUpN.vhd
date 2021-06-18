library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity CounterUpN is
	 generic(N	 : positive := 10);
	 port(clk	 : in std_logic; 
			reset  : in std_logic;
			done	 : out std_logic;
			count  : out std_logic_vector(6 downto 0));
end CounterUpN;

architecture Behavioral of CounterUpN is
	 signal s_count : unsigned(6 downto 0);
begin
	 process(clk)
	 begin
		if(reset = '1') then
			s_count <= (others => '0');
		else
			if (rising_edge(clk)) then
					if(s_count >= N-1) then
					done <= '1';
					s_count <= (others => '0');
					else
					done <= '0';
					s_count <= s_count + 1;
				end if;
			end if;
		end if;
	 end process;
	 count <= std_logic_vector(s_count);
end Behavioral;