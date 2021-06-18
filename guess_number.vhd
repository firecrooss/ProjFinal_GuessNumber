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
		  
		  att			 : in std_logic_vector(6 downto 0);
		  countatt	 : out std_logic;
		  gameover	 : out std_logic;
		  
		  middle		 : in std_logic_vector(6 downto 0);	
		  calcReset  : out std_logic;
		  calcRes	 : out std_logic_vector(1 downto 0);
		  calcCheater	 : in std_logic;
		  
		  ledr		 : out std_logic_vector(17 downto 0);
		  n_attempts : out std_logic_vector(6 downto 0);
		  activate	 : out std_logic;
		  attempt	 : out std_logic_vector(6 downto 0);
		  selector	 : out std_logic;
		  enable		 : out std_logic_vector(2 downto 0);
		  txt			 :	out std_logic_vector(39 downto 0));
end guess_number;

architecture Behavioral of guess_number is

type state is (start, waiting, guess, listenhi, listenlo, listeneq, cheater, win);
signal PS, NS : state;
signal s_txt1 : std_logic_vector(44 downto 0) := "111110101110000110101000110010111110101000100"; --GruPo 04
signal n_att : unsigned(6 downto 0) := "0000001";
signal s_done : unsigned(1 downto 0) := "00";
signal s_leds : std_logic_vector(17 downto 0) := "000000000000000000";
signal s_attempt : std_logic_vector(6 downto 0);

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
	
	gameover <= '1';
	
	txt <= "0101111010011010111001110111110111100001"; --guess_n1
	ledr <= (others => c1hz);
	enable  <= (others => c1hz);
	
	
	
	if(count10 = '1') then
		NS <= waiting;
	else
		NS <= start;
	end if;
	
when waiting =>
	
	enable  <= "111";
	
	gameover <= '1';
	
	selector <= '1';
	
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
		
		calcReset <= '1';

	if(keys(0) = '1') then
		
		NS <= guess;
	else
		
		NS <= waiting;
	end if;
	
when guess =>
		
		calcReset <= '0';
		
		calcRes <= "00";
		
		enable  <= "111";
		
		gameover <= '0';
		
		countatt <= '0';
		
		selector <= '0';
		
		attempt <= middle;
		
		n_attempts <= std_logic_vector(att);
		
		txt <= (others => '1');
		
		activate <= '1';
		
		if(calcCheater = '1') then
			NS <= cheater;
		else
			NS <= listenhi;
		end if;
		
when listenhi =>

	calcReset <= '0';

	enable  <= "111";
	
	gameover <= '0';
	
	selector <= '0';
	
	NS <= listenhi;
	
	txt(19 downto 0) <= "11111101001011111111"; --Hi
	
	if(keys(1) = '1') then
		NS <= listenlo;
	end if;
	
	if(keys(2) = '1') then
		countatt <= '1';
		calcRes <= "10";
		NS <= guess;
	end if;

when listenlo =>

	calcReset <= '0';
	
	enable  <= "111";
	
	gameover <= '0';
	
	selector <= '0';
	
	NS <= listenlo;
	
	txt(19 downto 0) <= "11111110001001011111"; --Lo
	
	if(keys(1) = '1') then
		NS <= listeneq;
	end if;
	
	if(keys(2) = '1') then
		countatt <= '1';
		calcRes <= "01";
		NS <= guess;
	end if;
	
when listeneq=>

	calcReset <= '0';
		
	enable  <= "111";
	
	gameover <= '0';
	
	selector <= '0';
	
	NS <= listeneq;
	
	txt(19 downto 0) <= "11111110011100111111"; --==
	
	if(keys(1) = '1') then
		NS <= listenhi;
	end if;
	
	if(keys(2) = '1') then
		NS <= win;
	end if;
		
when cheater =>
	
	gameover <= '1';
	
	selector <= '1';
	
	txt <= "1111110011101000110110101101100110110000"; -- CHEAtEr
	
	enable  <= (others => c4hz);
	
	calcReset <= '1';
	
	if(keys(3) = '1') then
		NS <= waiting;
	else
		NS <= cheater;
	end if;
	
when win =>
	
	selector <= '0';
	
	enable  <= (others => c2hz);
	
	txt <= (others => '1');
	
	gameover <= '1';
	
	calcReset <= '1';
	
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
calcReset <= '1';
txt <= (others => '1');
NS <= start;

end case;
end process;

end Behavioral;