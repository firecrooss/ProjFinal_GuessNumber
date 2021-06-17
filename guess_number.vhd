library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity guess_number is
	generic(dez : positive := 10);
	port(keys		 : in std_logic_vector(3 downto 0);
		  reset		 : in std_logic;
		  count10	 : in std_logic;
		  clk			 : in std_logic;
		  c1hz		 : in std_logic;
		  c2hz		 : in std_logic;
		  c4hz		 : in std_logic;
		  c8hz		 : in std_logic;
		  done1		 : in std_logic;
		  done2		 : in std_logic;
		  rnd			 : in std_logic_vector(17 downto 0);
		  ledr		 : out std_logic_vector(17 downto 0);
		  n_attempts : out std_logic_vector(6 downto 0);
		  activate	 : out std_logic;
		  attempt	 : out std_logic_vector(6 downto 0);
		  selector	 : out std_logic;
		  enable		 : out std_logic_vector(2 downto 0);
		  txt			 :	out std_logic_vector(39 downto 0));
end guess_number;

architecture Behavioral of guess_number is

type state is (start, waiting, guess, listen, cheater, win);
signal PS, NS : state;
signal s_txt1 : std_logic_vector(44 downto 0) := "111110101110000110101000110010111110101000100"; --GruPo 04
signal hi, lo, middle : integer;
signal n_att : unsigned(6 downto 0) := "0000000";
signal s_done : unsigned(1 downto 0) := "00";
signal s_res : unsigned(1 downto 0) := "00";
signal s_leds : std_logic_vector(17 downto 0) := "000000000000000000";

begin

process(clk)
begin
if(rising_edge(clk)) then
	if(reset = '1') then
	PS <= start;
	else
	PS <= NS;
	end if;
end if;
end process;

process(PS, keys, clk)
begin

txt <= (others => '1');
ledr <= (others => '0');

case PS is

when start =>

	selector <= '1';

	txt <= "0101101100011010111001110111110111100001"; --guess_n1
	ledr <= (others => c1hz);
	enable  <= (others => c1hz);

	if(count10 = '1') then
		NS <= waiting;
	else
		NS <= start;
	end if;
	
when waiting =>
	
	enable  <= "111";
	
	selector <= '1';

	if(keys(0) = '1') then
		
		NS <= guess;
	else
		
		if(rising_edge(c1hz)) then
		
		s_txt1(44 downto 40) <= s_txt1(39 downto 35);
		s_txt1(39 downto 35) <= s_txt1(34 downto 30);
		s_txt1(34 downto 30) <= s_txt1(29 downto 25);
		s_txt1(29 downto 25) <= s_txt1(24 downto 20);
		s_txt1(24 downto 20) <= s_txt1(19 downto 15);
		s_txt1(19 downto 15) <= s_txt1(14 downto 10);
		s_txt1(14 downto 10) <= s_txt1(9 downto 5);
		s_txt1(9 downto 5) <= s_txt1(4 downto 0);
		s_txt1(4 downto 0) <= s_txt1(44 downto 40);
		
		end if;
		
		txt <= s_txt1(44 downto 5);
		
		hi <= 99;
		lo <= 0;
		
		NS <= waiting;
	end if;
	
when guess =>
		
		enable  <= "111";
		
		s_done <= "00";
		
		if(lo > hi) then
			NS <= cheater;
		end if;
		
		selector <= '0';
		
		middle <= (lo + hi + 1)/2;
		
		attempt <= std_logic_vector(to_unsigned(middle, 7));
		
		n_att <= n_att + 1;
		
		n_attempts <= std_logic_vector(n_att);
		
		txt <= (others => '1');
		
		activate <= '1';
		
		if(done1 = '1') then
			s_done(0) <= '1';
		end if;
		
		if(done2 = '1') then
			s_done(1) <= '1';
		end if;
		
		if(s_done = "11") then
			s_done <= "00";
			NS <= listen;
		else
			NS <= guess;
		end if;
		
when listen =>
	
	enable  <= "111";
	
	selector <= '0';
	
	NS <= listen;
	
	txt <= (others => '1');
	
	case s_res is
	when "00" =>
		
	txt(19 downto 0) <= "11111101001011111111"; --Hi
	
	if(keys(1) = '1') then
		s_res <= "01";
	end if;
	
	if(keys(2) = '1') then
		hi <= middle-1;
		NS <= guess;
	end if;
		
	when "01"=>
	
	txt(19 downto 0) <= "11111110001001011111"; --Lo
	
	if(keys(1) = '1') then
		s_res <= "10";
	end if;
	
	if(keys(2) = '1') then
		lo <= middle+1;
		NS <= guess;
	end if;
	
	when "10"=>
	
	txt(19 downto 0) <= "11111110011100111111"; --==
	
	if(keys(1) = '1') then
		s_res <= "00";
	end if;
	
	if(keys(2) = '1') then
		NS <= win;
	end if;
	
	when others=>
	txt <= (others => '1');
	s_res <= "00";
	NS <= listen;
	end case;
		
when cheater =>
	
	selector <= '1';
	
	txt <= "1111110011101000110110101101100110110000"; -- CHEAtEr
	
	enable  <= (others => c4hz);
	
	if(keys(3) = '1') then
		NS <= waiting;
	else
		NS <= cheater;
	end if;
	
when win =>
	
	selector <= '0';
	
	enable  <= (others => c2hz);
	
	txt <= (others => '1');
	
	if(rising_edge(c8hz)) then
		s_leds <= rnd(17 downto 0);
	end if;
	
	ledr <= s_leds(17 downto 0);
	
	if(keys(3) = '1') then
		NS <= waiting;
	else
		NS <= win;
	end if;
	
when others =>
txt <= (others => '1');
NS <= start;

end case;
end process;

end Behavioral;