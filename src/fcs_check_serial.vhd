library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fcs_check_serial is
  port (clk            : in  std_logic;
        reset          : in  std_logic;
        start_of_frame : in  std_logic;
        end_of_frame   : in  std_logic;  -- Arrival of the first bit in CRC checksum.
        data_in        : in  std_logic;
        fcs_error      : out std_logic);
end fcs_check_serial;

architecture behavioral of fcs_check_serial is
  -- Remainder shift register
  signal R           : std_logic_vector(31 downto 0);

  signal shift_count : unsigned(4 downto 0);
  signal data        : std_logic;
  signal fcs_done    : std_logic;
begin

  -- Complement the first and last 32 bits of the frame by waiting for the
  -- first and last bit of the frame or by ensuring an appropriate amount of
  -- shifts are performed.
  process (shift_count, start_of_frame, end_of_frame, data_in)
  begin
    data <= data_in;

    if shift_count < 31 or start_of_frame = '1' or end_of_frame = '1' then
      data <= not data_in;
    end if;
  end process;

  -- Serial linear feedback shift register logic.
  process (clk, reset)
  begin
    if reset = '1' then
      R           <= (others => '0');
      shift_count <= (others => '0');
      fcs_error   <= '1';
    elsif rising_edge(clk) then
      if end_of_frame = '1' then
        fcs_done <= '1';
      end if;

      if start_of_frame = '1' or end_of_frame = '1' then
        shift_count <= (others => '0');
      elsif shift_count < 31 then
        shift_count <= shift_count + 1;
      end if;

      -- Serial linear feedback shift registers:
      --
      -- The generator polynomial is given by:
      -- 1 0000010 011000001 00011101 10110111
      -- MSB                               LSB
      R(0) <= data xor R(31);           -- x^0
      R(1) <= R(0) xor R(31);           -- x^1
      R(2) <= R(1) xor R(31);           -- x^2
      R(3) <= R(2);
      R(4) <= R(3) xor R(31);           -- x^4
      R(5) <= R(4) xor R(31);           -- x^5
      R(6) <= R(5);
      R(7) <= R(6) xor R(31);           -- x^7

      R(8)  <= R(7) xor R(31);          -- x^8
      R(9)  <= R(8);
      R(10) <= R(9) xor R(31);          -- x^10
      R(11) <= R(10) xor R(31);         -- x^11
      R(12) <= R(11) xor R(31);         -- x^12
      R(13) <= R(12);
      R(14) <= R(13);
      R(15) <= R(14);

      R(16) <= R(15) xor R(31);         -- x^16
      R(17) <= R(16);
      R(18) <= R(17);
      R(19) <= R(18);
      R(20) <= R(19);
      R(21) <= R(20);
      R(22) <= R(21) xor R(31);         -- x^22
      R(23) <= R(22) xor R(31);         -- x^23
      R(24) <= R(23);

      R(25) <= R(24);
      R(26) <= R(25) xor R(31);         -- x^26
      R(27) <= R(26);
      R(28) <= R(27);
      R(29) <= R(28);
      R(30) <= R(29);
      R(31) <= R(30);
      -- R(31) is x^32

      if R = "00000000000000000000000000000000" and fcs_done = '1' then
        fcs_error <= '0';
      end if;
    end if;
  end process;

end behavioral;
