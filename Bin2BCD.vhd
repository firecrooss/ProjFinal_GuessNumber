library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Bin2BCD is
	port(bin    : in  std_logic_vector(6 downto 0);
		  clk    : in  std_logic;
		  reset  : in  std_logic;
		  done   : out std_logic;
		  start  : in  std_logic;
		  digit1 : out std_logic_vector(3 downto 0);
		  digit0 : out std_logic_vector(3 downto 0));
		  
end Bin2BCD;

architecture Behav of Bin2BCD is

	type TState is (IDLE, DEC10, FINISH);
	signal State : TState;
	signal num : unsigned(6 downto 0);
	signal s_dig1 : unsigned(3 downto 0);
	
begin

	
	sync_proc: process(clk)
	begin
	
		if (rising_edge(clk)) then
			done <= '0';
			case State is
			
			when IDLE =>
				if (start = '1') then
					State <= DEC10;
					num <= unsigned(bin);
					s_dig1 <= (others => '0');
				end if;
				
			when DEC10 =>
				if (num >= 10) then
					num <= num - 10;
					s_dig1 <= s_dig1 + 1;
				else
					State <= FINISH;
				end if;
				
			when FINISH =>
				done <= '1';
				State <= IDLE;
			end case;
			
			if (reset = '1') then
				done <= '0';
				num <= (others => '0');
				s_dig1 <= (others => '0');
			end if;
		end if;
			
	end process;
	
	digit1 <= std_logic_vector(s_dig1);
	digit0 <= std_logic_vector(num(3 downto 0));
	
end Behav;
		