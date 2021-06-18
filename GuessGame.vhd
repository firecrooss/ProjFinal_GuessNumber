library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity GuessGame is
	 port(KEY		: in std_logic_vector(3 downto 0);
			SW			: in std_logic_vector(1 downto 0);
			CLOCK_50 : in std_logic;
			LEDR		: out std_logic_vector(17 downto 0);
			HEX7		: out std_logic_vector(6 downto 0);
			HEX6		: out std_logic_vector(6 downto 0);
			HEX5		: out std_logic_vector(6 downto 0);
			HEX4		: out std_logic_vector(6 downto 0);
			HEX3		: out std_logic_vector(6 downto 0);
			HEX2		: out std_logic_vector(6 downto 0);
			HEX1		: out std_logic_vector(6 downto 0);
			HEX0		: out std_logic_vector(6 downto 0));
end GuessGame;

architecture Structural of GuessGame is
signal s_c1hz, s_c2hz, s_c4hz, s_c8hz : std_logic;
signal s_n_attempts, s_attempt : std_logic_vector(6 downto 0);
signal s_activate, s_done1, s_done2, s_selector : std_logic;
signal s_enable : std_logic_vector(2 downto 0);
signal s_txt : std_logic_vector(39 downto 0);
signal s_rnd : std_logic_vector(17 downto 0);
signal s_d7, s_d6, s_d5, s_d4 : std_logic_vector(3 downto 0);
signal s_bin7, s_bin6, s_bin5, s_bin4, s_bin3, s_bin2, s_bin1, s_bin0 : std_logic_vector(4 downto 0);
signal s_enable7, s_enable6, s_enable5, s_enable4, s_enable3, s_enable2, s_enable1, s_enable0 : std_logic;
signal s_count10 : std_logic;
signal s_countatt, s_gameover : std_logic;
signal s_att : std_logic_vector(6 downto 0);

signal s_hiIn, s_hiOut, s_loIn, s_loOut : std_logic_vector(6 downto 0);
signal s_regEnable : std_logic;
signal s_middle : std_logic_vector(6 downto 0);
signal s_result : std_logic_vector(1 downto 0);
signal s_calcEnable, s_calcReset, s_cheater : std_logic;

signal s_sw : std_logic_vector(1 downto 0);
signal s_key : std_logic_vector(3 downto 0);

begin

debouncer1 : entity work.debouncer(fancy)
		port map(clock => CLOCK_50,
					reset => '0',
					dirty => SW(0),
					clean => s_sw(0));
					
debouncer2 : entity work.debouncer(fancy)
		port map(clock => CLOCK_50,
					reset => s_sw(0),
					dirty => SW(1),
					clean => s_sw(1));
					
debouncer3 : entity work.debouncer(fancy)
		port map(clock => CLOCK_50,
					reset => s_sw(0),
					dirty => KEY(0),
					one_to_zero_pulse => s_key(0));
					
debouncer4 : entity work.debouncer(fancy)
		port map(clock => CLOCK_50,
					reset => s_sw(0),
					dirty => KEY(1),
					one_to_zero_pulse => s_key(1));
					
debouncer5 : entity work.debouncer(fancy)
		port map(clock => CLOCK_50,
					reset => s_sw(0),
					dirty => KEY(2),
					one_to_zero_pulse => s_key(2));
					
debouncer6 : entity work.debouncer(fancy)
		port map(clock => CLOCK_50,
					reset => s_sw(0),
					dirty => KEY(3),
					one_to_zero_pulse => s_key(3));

					

count10 : entity work.CounterUpN(Behavioral)
		port map(clk => s_c1hz,
					reset => s_sw(0),
					done => s_count10);

					
					
divfreq : entity work.freq_divider(RTL)
		port map(clkIn => CLOCK_50,
					c1hz => s_c1hz,
					c2hz => s_c2hz,
					c4hz => s_c4hz,
					c8hz => s_c8hz);
	

	
random : entity work.pseudo_random_generator(light)
		port map(clock => CLOCK_50,
					rnd => s_rnd);
	

	
binbcd1 : entity work.Bin2BCD(Behav)
		port map(bin => s_n_attempts,
					clk => CLOCK_50,
					reset => s_sw(0),
					done => s_done1,
					start => s_activate,
					digit1 => s_d7,
					digit0 => s_d6);
					
binbcd2 : entity work.Bin2BCD(Behav)
		port map(bin => s_attempt,
					clk => CLOCK_50,
					reset => s_sw(0),
					done => s_done2,
					start => s_activate,
					digit1 => s_d5,
					digit0 => s_d4);


					
display : entity work.display_selector(Behavioral)
		port map(d7 => s_d7,
					d6 => s_d6,
					d5 => s_d5,
					d4 => s_d4,
					selector => s_selector,
					enable => s_enable,
					txt => s_txt,
					bin7 => s_bin7,
					bin6 => s_bin6,
					bin5 => s_bin5,
					bin4 => s_bin4,
					bin3 => s_bin3,
					bin2 => s_bin2,
					bin1 => s_bin1,
					bin0 => s_bin0,
					enable7 => s_enable7,
					enable6 => s_enable6,
					enable5 => s_enable5,
					enable4 => s_enable4,
					enable3 => s_enable3,
					enable2 => s_enable2,
					enable1 => s_enable1,
					enable0 => s_enable0);


					
dec1 : entity work.decoder(Behavioral)
		port map(bin => s_bin7,
					enable => s_enable7,
					hex => HEX7);
					
dec2 : entity work.decoder(Behavioral)
		port map(bin => s_bin6,
					enable => s_enable6,
					hex => HEX6);
					
dec3 : entity work.decoder(Behavioral)
		port map(bin => s_bin5,
					enable => s_enable5,
					hex => HEX5);
					
dec4 : entity work.decoder(Behavioral)
		port map(bin => s_bin4,
					enable => s_enable4,
					hex => HEX4);
					
dec5 : entity work.decoder(Behavioral)
		port map(bin => s_bin3,
					enable => s_enable3,
					hex => HEX3);
					
dec6 : entity work.decoder(Behavioral)
		port map(bin => s_bin2,
					enable => s_enable2,
					hex => HEX2);
					
dec7 : entity work.decoder(Behavioral)
		port map(bin => s_bin1,
					enable => s_enable1,
					hex => HEX1);
					
dec8 : entity work.decoder(Behavioral)
		port map(bin => s_bin0,
					enable => s_enable0,
					hex => HEX0);
					
countatt : entity work.CounterUpN(Behavioral)
		generic map(N => 99)
		port map(clk => s_countatt,
					reset => s_gameover,
					count => s_att);
	

attcalc : entity work.attemptcalc(Behavioral)
		port map(clk => CLOCK_50,
					enable => s_calcEnable,
					reset => s_calcReset,
					dataIn => s_result,
					attempt => s_middle,
					cheater => s_cheater);
					
					
					
gn : entity work.guess_number(Behavioral)
		port map(keys => s_key,
					ledr => LEDR,
					reset => s_sw(0),
					count10 => s_count10,
					clk => CLOCK_50,
					c1hz => s_c1hz,
					c2hz => s_c2hz,
					c4hz => s_c4hz,
					c8hz => s_c8hz,
					done1 => s_done1,
					done2 => s_done2,
					rnd => s_rnd,
					n_attempts => s_n_attempts,
					attempt => s_attempt,
					activate => s_activate,
					selector => s_selector,
					enable => s_enable,
					txt => s_txt,
					
					middle => s_middle,
					calcReset => s_calcReset,
					calcEnable => s_calcEnable,
					calcRes => s_result,
					calcCheater => s_cheater,
					
					gameover => s_gameover,
					countatt => s_countatt,
					att => s_att);
					

end Structural;