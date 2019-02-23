library ieee;
use ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all; 
USE IEEE.STD_LOGIC_UNSIGNED.all;

entity clock_12h is
	port
	(
		-- Input ports
		clk_50, key_reset, key_hr, key_min, key_sec, key_start	:in  std_logic;
		-- Output ports
		sec_low, sec_high, min_low, min_high, hr_low, hr_high		:out  std_logic_vector(3 downto 0)
	);
end clock_12h;


architecture A of clock_12h is

	-- Declarations (optional)
	signal internal_count: std_logic_vector(28 downto 0);
	signal clk_1hz : std_logic;
	
begin
	-- reduce the frequency from 50Mhz down to 1Hz
	process(clk_50)
	begin
		if (clk_50'event and clk_50 ='1') then
			if (internaL-count < 25000000) then
				internal_count <= internal_count +1;
			else
				internal count <= (others => '0');
				clk_1hz <= not clk_1hz;
			end if;
		end if;
	end process;
	
	sec_low <= 0;
	sec_high <= 0;
	min_low <= 0;
	min_high <= 0;
	hr_low <= 1;
	hr_high <= 0;
	
	-- Set sec
	process(key_sec)
	begin
		if (rising_edge(key_sec)) then
			if (sec_low = 9) then
				sec_low <= 0;
				if (sec_high = 5) then
					sec_high <= 0;
				else
					sec_high <= sec_high +1;
				end if;
			else
				sec_low <= sec_low +1;
			end if;
		end if;
	end process;
	
	-- Set min
	process(key_min)
	begin
		if (rising_edge(key_min)) then
			if (min_low = 9) then
				sec_low <= 0;
				if (min_high = 5) then
					min_high <= 0;
				else
					min_high <= min_high +1;
				end if;
			else
				min_low <= min_low +1;
			end if;
		end if;
	end process;

		-- Set hr
	process(key_hr)
	begin
		if (rising_edge(key_hr)) then
			if (min_low = 9) then
				sec_low <= 0;
				if (min_high = 5) then
					min_high <= 0;
				else
					min_high <= min_high +1;
				end if;
			else
				min_low <= min_low +1;
			end if;
		end if;
	end process;
	-- Process Statement; (optional)

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end <arch_name>;
