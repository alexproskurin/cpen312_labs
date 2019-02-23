library ieee;
use ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all; 
USE IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity clock_12h is
	port
	(
		-- Input ports
		clk_50, key_reset, key_hr, key_min, key_sec, key_start	:in  std_logic;
		-- Output ports
		sec_l, sec_h, min_l, min_h, hr_l, hr_h		:out  std_logic_vector(3 downto 0)
	);
end clock_12h;


architecture A of clock_12h is

	-- Declarations (optional)
	signal internal_count: std_logic_vector(28 downto 0);
	signal hr_reset: std_logic;
	signal hr_reset_t: std_logic;
	signal clk_1hz : std_logic;
	signal sec_low, sec_high, min_low, min_high, hr_low, hr_high : integer := 0;
	signal sec_low_t, sec_high_t, min_low_t, min_high_t, hr_low_t, hr_high_t : integer := 0;
	signal sec_carry, min_carry : integer := 0;
	
begin
	-- reduce the frequency from 50Mhz down to 1Hz
	process(clk_50)
	begin
		if (clk_50'event and clk_50 ='1') then
			if (internal_count < 25000000) then
				internal_count <= internal_count +1;
			else
				internal_count <= (others => '0');
				clk_1hz <= not clk_1hz;
			end if;
		end if;
	end process;
	
--	sec_low_t <= 0;
--	sec_high_t <= 0;
--	min_low_t <= 0;
--	min_high_t <= 0;
--	hr_low_t <= 1;
--	hr_high_t <= 0;
--	hr_reset_t <= '0';
	-- Set sec
	process(key_sec)
	begin
		if (rising_edge(key_sec)) then
			if (sec_low_t = 9) then
				sec_low_t <= 0;
				if (sec_high_t = 5) then
					sec_high_t <= 0;
				else
					sec_high_t <= sec_high_t +1;
				end if;
			else
				sec_low_t <= sec_low_t +1;
			end if;
		end if;
	end process;
	
	-- Set min
	process(key_min)
	begin
		if (rising_edge(key_min)) then
			if (min_low_t = 9) then
				min_low_t <= 0;
				if (min_high_t = 5) then
					min_high_t <= 0;
				else
					min_high_t <= min_high_t +1;
				end if;
			else
				min_low_t <= min_low_t +1;
			end if;
		end if;
	end process;

	-- Set hr
	process(key_hr)
	begin
		if (rising_edge(key_hr)) then
			if (hr_reset_t = '0') then
				if (hr_low_t = 9) then
					hr_low_t <= 0;
					hr_reset_t <= '1';
					if (hr_high_t = 1) then
						hr_high_t <= 0;
					else
						hr_high_t <= hr_high_t +1;
					end if;
				else
					hr_low_t <= hr_low_t +1;
				end if;
			else
				if (hr_low_t = 2) then
					hr_low_t <= 1;
					hr_reset_t <= '0';
					if (hr_high_t = 1) then
						hr_high_t <= 0;
					else
						hr_high_t <= hr_high_t +1;
					end if;
				else
					hr_low_t <= hr_low_t +1;
				end if;
			end if;
		end if;
	end process;
	
	--STARTING THE CLOCK
	process(key_start, sec_low_t, sec_high_t, min_low_t, min_high_t, hr_low_t, hr_high_t, hr_reset_t, clk_1hz)
	begin
	if (key_start = '1') then
		if (rising_edge(clk_1hz)) then
			-- INCREMENT SECONDS
			if (sec_low = 9) then
				sec_low <= 0;
				if (sec_high = 5) then
					sec_high <= 0;
					sec_carry <= 1;
				else
					sec_high <= sec_high +1;
				end if;
			else
				sec_low <= sec_low +1;
			end if;
			-- INCREMENT MINUTES
			if (sec_carry = 1) then
				if (min_low = 9) then
					min_low <= 0;
					if (min_high = 5) then
						min_high <= 0;
						min_carry <= 1;
					else
						min_high <= min_high +1;
					end if;
				else
					min_low <= min_low +1;
				end if;
				sec_carry <= 0;
			end if;
			-- INCREMENT HOURS
			if (min_carry = 1) then
				if (hr_reset = '0') then
					if (hr_low = 9) then
						hr_low <= 0;
						hr_reset <= '1';
						if (hr_high = 1) then
							hr_high <= 0;
						else
							hr_high <= hr_high +1;
						end if;
					else
						hr_low <= hr_low +1;
					end if;
				else
					if (hr_low = 2) then
						hr_low <= 1;
						hr_reset <= '0';
						if (hr_high = 1) then
							hr_high <= 0;
						else
							hr_high <= hr_high +1;
						end if;
					else
						hr_low <= hr_low +1;
					end if;
				end if;
				min_carry <= 0;
			end if;
		end if;
	else
		sec_low <= sec_low_t;
		sec_high <= sec_high_t;
		min_low <= min_low_t;
		min_high <= min_high_t;
		hr_low <= hr_low_t;
		hr_high <= hr_high_t;
		hr_reset <= hr_reset_t;
	end if;
	end process;	
	
	-- Process Statement; (optional)

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)
sec_l <= std_logic_vector(to_unsigned(sec_low, sec_l'length));
sec_h <= std_logic_vector(to_unsigned(sec_high, sec_h'length));
min_l <= std_logic_vector(to_unsigned(min_low, min_l'length));
min_h <= std_logic_vector(to_unsigned(min_high, min_h'length));
hr_l <= std_logic_vector(to_unsigned(hr_low, hr_l'length));
hr_h <= std_logic_vector(to_unsigned(hr_high, hr_h'length));
end A;
