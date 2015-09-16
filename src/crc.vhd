entity fcs_check_serial is
  port (
    clk            : in  std_logic;     -- system clock
    reset          : in  std_logic;     -- asynchronous reset
    start_of_frame : in  std_logic;     -- arrival of the first bit.
    end_of_frame   : in  std_logic;     -- arrival of the first bit in FCS.
    data_in        : in  std_logic;     -- serial input data.
    fcs_error      : out std_logic;     -- indicates an error.
    );
end fcs_check_serial;

architecture behavioral of fcs_check_serial is
  -- 32 bit shift register filled with 0's
  signal R : std_logic_vector(31 downto 0) := (others => '0');
begin
  -- Arrival of the first bit, and start of the shift register
  process(start_of_frame, clk, reset)
  begin
    if reset = '1' then
      -- Reset the shift register and fill it with 0's
			R <= (others => '0');
		else
			if rising_edge(clk) then
        -- Loop through the shift register, skipping the first value, since that
        -- is different
        
        for i in (R'LENGTH - 1) downto 1 loop
          -- Shift the register
        end loop;
			end if;
		end if;
  end
  -- All data has been received, and we can now check for errors
  process(end_of_frame)
  begin
    if (unsigned(R) = 0) and end_of_frame then
      fcs_error <= 1;
    end;
  end
end behavioral;
