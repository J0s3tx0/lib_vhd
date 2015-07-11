-------------------------------------------------------------------------------
-- Title      : ctr_n
-- Project    : Any
-------------------------------------------------------------------------------
-- File       : ctr_n.vhd
-- Company    : Tredess 2010 SL.
-- Last update: 2013/03/01
-- Platform   : Any
-------------------------------------------------------------------------------
-- Description:
-- 	n bits counter.
-- Features: 
--		- Parallel load
--		- Up/down count
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctr_n is
  generic(
    N         :     positive := 4;
    VAL_MAX   :     positive := 15;
    VAL_RESET :     natural := 0
	 );	 
  port(
    clk       : in  std_logic;
    reset_n   : in  std_logic;
    pload     : in  std_logic;								-- Parallel load enable
    en        : in  std_logic;
    pdata     : in  std_logic_vector(N - 1 downto 0);	-- Init value
    u_d       : in  std_logic;								-- '0' => up count; '1' => down count
    q         : out std_logic_vector(N - 1 downto 0); -- Count value
    end_ctr   : out std_logic									-- End of the count
	 );
end entity;

architecture CTR_N_BEH of ctr_n is

  signal c : std_logic_vector(N - 1 downto 0) := (others => '0');

begin

P_CTR : process (clk, reset_n, en)
  begin
  
		--------------------------------------
		-- Reset
		--------------------------------------
		if reset_n = '0' then
			c <= std_logic_vector(to_unsigned(VAL_RESET, N));
			if VAL_RESET = VAL_MAX then
				end_ctr <= '1';
			else
				end_ctr <= '0';
			end if;
		
		elsif clk = '1' and clk'event and en = '1' then
			
			--------------------------------------
			-- Parallel load
			--------------------------------------
			if PLOAD = '1' then
				c   		<= pdata;
				end_ctr 	<= '0';
				
			--------------------------------------
			-- Up count
			--------------------------------------				
			elsif u_d = '0' then
				if to_integer(unsigned(c)) = VAL_MAX - 1 then
					end_ctr <= '1';
				else
					end_ctr <= '0';
				end if;

				if to_integer(unsigned(c)) < VAL_MAX then
					c <= std_logic_vector (( unsigned(c) + to_unsigned(1, N)));
				else
					c <= (others => '0');
				end if;

			--------------------------------------
			-- Down count
			--------------------------------------					
			else
			  if to_integer(unsigned(c)) = 0 then
				 end_ctr <= '1';
			  else
				 end_ctr <= '0';
			  end if;

			  if to_integer(unsigned(c)) > 0 then
				 c <= std_logic_vector( ( unsigned(c) - to_unsigned(1, N)));
			  else
				 c <= std_logic_vector( to_unsigned(VAL_MAX, N));
			  end if;
			end if;	
		end if;
  end process;
  
  q <= c;
  
end architecture;