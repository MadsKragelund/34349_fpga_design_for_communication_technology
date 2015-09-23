library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity fcs_check_serial is
  port (clk            : in  std_logic;   -- system clock
        reset          : in  std_logic;   -- asynchronous reset
        start_of_frame : in  std_logic;   -- arrival of the first bit.
        end_of_frame   : in  std_logic;   -- arrival of the first bit in FCS.
        data_in        : in  std_logic;   -- serial input data.
        fcs_error      : out std_logic);  -- indicates an error.
end fcs_check_serial;

architecture behavioral of fcs_check_serial is
  -- 32 bit shift register filled with 0's
  signal R               : std_logic_vector(31 downto 0) := (others => '0');
  -- Previous output from the shift register
  signal previous_output : std_logic_vector(1 downto 0)  := (others => '0');
begin
  -- Arrival of the first bit, and start of the shift register
  process(start_of_frame, clk, reset)
    variable R_temp : std_logic_vector(31 downto 0) := (others => '0');
    variable l      : line;
  begin
    if reset = '1' then
      -- Reset the shift register and fill it with 0's
      R <= (others => '0');
    else
      if rising_edge(clk) then
        -- Shift the vector
        R_temp := R(R'length - 2 downto 0) & data_in;
        -- xor it with the last bit in the vector
        for i in R'range loop
          R_temp(i) := R_temp(i) xor previous_output(0);
        end loop;
        R                  <= R_temp;
        previous_output(0) <= R(R'length - 1);
      end if;
    end if;
  end process;
  -- All data has been received, and we can now check for errors
  process(end_of_frame)
  begin
  -- if (unsigned(R) = 0) and end_of_frame then
  --   fcs_error <= '1';
  -- end if;
  end process;
end behavioral;
