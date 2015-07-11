-------------------------------------------------------------------------------
-- Title      : bcd_2_7seg
-- Project    : Any
-------------------------------------------------------------------------------
-- File       : bcd_2_7seg.vhd
-- Last update: 2013/03/21
-- Platform   : Any
-------------------------------------------------------------------------------
-- Description:
--		BCD to 7 Segment Converter
--
--     (0)
--      _
-- (5) | | (1)
--      -  (6)
-- (4) | | (2)
--      -  
--     (3)	* (7)
--
-- José Manuel Fernández Carrillo.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_2_7seg is
	generic (
		DISPLAY_TYPE : std_logic := '0' -- '0' --> active low; '1' --> active high
	);
	port(
		d 	: in  std_logic_vector(3 downto 0); -- BCD input
		q : out  std_logic_vector (6 downto 0) -- 7 segment output
		);
end bcd_2_7seg;
		
architecture rtl of bcd_2_7seg is

---------------------------------------------------
-- SIGNALS
---------------------------------------------------
signal q_aux : std_logic_vector(6 downto 0);

begin


SEL_Q: with d select
			q_aux	<=	"1111001" when "0001", -- 1
														"0100100" when "0010", -- 2
														"0110000" when "0011", -- 3
														"0011001" when "0100", -- 4
														"0010010" when "0101", -- 5
														"0000010" when "0110", -- 6
														"1111000" when "0111", -- 7
														"0000000" when "1000", -- 8
														"0010000" when "1001", -- 9
														"0001000" when "1010", -- A
														"0000011" when "1011", -- B
														"1000110" when "1100", -- C
														"0100001" when "1101", -- D
														"0000110" when "1110", -- E
														"0001110" when "1111", -- F
														"1000000" when others; -- 0
														
-- Active low																	
GEN_TYPE_0: if DISPLAY_TYPE = '0' generate
	q <= q_aux;
end generate;

-- Active high
GEN_TYPE_1: if DISPLAY_TYPE = '1' generate
	q <= not q_aux;
end generate;				
										
end rtl;