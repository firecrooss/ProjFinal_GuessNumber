library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity decoder is
	port(enable : in std_logic;
		  bin	: in  std_logic_vector(4 downto 0);
		  hex	: out std_logic_vector(6 downto 0));
end decoder;

architecture Behavioral of decoder is	
	begin
	process(bin, enable)
	begin
		if(enable = '1') then
				case bin is
					when "00001" => hex <= "1111001"; --1
					when "00010" => hex <= "0100100"; --2
					when "00011" => hex <= "0110000"; --3
					when "00100" => hex <= "0011001"; --4
					when "00101" => hex <= "0010010"; --5
					when "00110" => hex <= "0000010"; --6
					when "00111" => hex <= "1111000"; --7
					when "01000" => hex <= "0000000"; --8
					when "01001" => hex <= "0010000"; --9
					when "01010" => hex <= "1000000"; --0
					when "01011" => hex <= "0000010"; --G
					when "01100" => hex <= "0111110"; --U
					when "01101" => hex <= "0000110"; --E
					when "01110" => hex <= "0010010"; --S
					when "01111" => hex <= "0101011"; --n
					when "10000" => hex <= "0101111"; --r
					when "10001" => hex <= "0001100"; --P
					when "10010" => hex <= "0100011"; --o
					when "10011" => hex <= "1000110"; --C
					when "10100" => hex <= "0001001"; --H
					when "10101" => hex <= "0001000"; --A
					when "10110" => hex <= "0000111"; --t
					when "10111" => hex <= "1101111"; --i
					when "11000" => hex <= "1000111"; --L
					when "11001" => hex <= "0110111"; --=
					when "11010" => hex <= "1100011"; --u
					when others => hex <= "1111111"; --	
				end case;
			else
				hex <= "1111111";
			end if;		
	end process;
end Behavioral;
