library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fcs_check_parallel is
  port (clk            : in  std_logic;
        reset          : in  std_logic;
        start_of_frame : in  std_logic;
        end_of_frame   : in  std_logic;  -- Arrival of the first byte in CRC checksum.
        data_in        : in  std_logic_vector(7 downto 0);
        fcs_error      : out std_logic);
end fcs_check_parallel;

architecture behavioral of fcs_check_parallel is
  -- Remainder shift register
  signal R           : std_logic_vector(31 downto 0);

  signal shift_count : unsigned(1 downto 0);
  signal data        : std_logic_vector(7 downto 0);
  signal fcs_done    : std_logic;
begin

  -- Complement the first and last 32 bits of the frame by waiting for the
  -- first and last bit of the frame or by ensuring an appropriate amount of
  -- shifts are performed.
  process (shift_count, start_of_frame, end_of_frame, data_in)
  begin
    data <= data_in;

    if shift_count < 3 or start_of_frame = '1' or end_of_frame = '1' then
      data <= not data_in;
    end if;
  end process;

  -- 8-bit parallel linear feedback shift register logic based on a shift
  -- matrix.
  process (clk, reset)
  begin
    if reset = '1' then
      R           <= (others => '0');
      shift_count <= (others => '0');
      fcs_error   <= '1';
      fcs_done    <= '0';
    elsif rising_edge(clk) then
      if end_of_frame = '1' then
        fcs_done <= '1';
      end if;

      if start_of_frame = '1' or end_of_frame = '1' then
        shift_count <= (others => '0');
      elsif shift_count < 3 then
        shift_count <= shift_count + 1;
      end if;

      R(0) <= R(24) xor R(30) xor data(0);
      R(1) <= R(24) xor R(25) xor R(30) xor R(31) xor data(1);
      R(2) <= R(24) xor R(25) xor R(26) xor R(30) xor R(31) xor data(2);
      R(3) <= R(25) xor R(26) xor R(27) xor R(31) xor data(3);
      R(4) <= R(24) xor R(26) xor R(27) xor R(28) xor R(30) xor data(4);
      R(5) <= R(24) xor R(25) xor R(27) xor R(28) xor R(29) xor R(30) xor
              R(31) xor data(5);
      R(6) <= R(25) xor R(26) xor R(28) xor R(29) xor R(30) xor R(31) xor
              data(6);
      R(7)  <= R(24) xor R(26) xor R(27) xor R(29) xor R(31) xor data(7);
      R(8)  <= R(0) xor R(24) xor R(25) xor R(27) xor R(28);
      R(9)  <= R(1) xor R(25) xor R(26) xor R(28) xor R(29);
      R(10) <= R(2) xor R(24) xor R(26) xor R(27) xor R(29);
      R(11) <= R(3) xor R(24) xor R(25) xor R(27) xor R(28);
      R(12) <= R(4) xor R(24) xor R(25) xor R(26) xor R(28) xor R(29) xor
               R(30);
      R(13) <= R(5) xor R(25) xor R(26) xor R(27) xor R(29) xor R(30) xor
               R(31);
      R(14) <= R(6) xor R(26) xor R(27) xor R(28) xor R(30) xor R(31);
      R(15) <= R(7) xor R(27) xor R(28) xor R(29) xor R(31);
      R(16) <= R(8) xor R(24) xor R(28) xor R(29);
      R(17) <= R(9) xor R(25) xor R(29) xor R(30);
      R(18) <= R(10) xor R(26) xor R(30) xor R(31);
      R(19) <= R(11) xor R(27) xor R(31);
      R(20) <= R(12) xor R(28);
      R(21) <= R(13) xor R(29);
      R(22) <= R(14) xor R(24);
      R(23) <= R(15) xor R(24) xor R(25) xor R(30);
      R(24) <= R(16) xor R(25) xor R(26) xor R(31);
      R(25) <= R(17) xor R(26) xor R(27);
      R(26) <= R(18) xor R(24) xor R(27) xor R(28) xor R(30);
      R(27) <= R(19) xor R(25) xor R(28) xor R(29) xor R(31);
      R(28) <= R(20) xor R(26) xor R(29) xor R(30);
      R(29) <= R(21) xor R(27) xor R(30) xor R(31);
      R(30) <= R(22) xor R(28) xor R(31);
      R(31) <= R(23) xor R(29);

      if R = "00000000000000000000000000000000" and fcs_done = '1' then
        fcs_error <= '0';
      end if;
    end if;
  end process;

end behavioral;
