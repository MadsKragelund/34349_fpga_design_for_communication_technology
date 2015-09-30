library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity fcs_check_serial is
  port (clk            : in  std_logic;   -- system clock
        reset          : in  std_logic;   -- asynchronous reset
        start_of_frame : in  std_logic;   -- arrival of the first bit.
        end_of_frame   : in  std_logic;   -- arrival of the first bit in FCS.
        data_in        : in  std_logic;   -- serial input data.
        fcs_error      : out std_logic);  -- indicates an error.
end fcs_check_serial;

architecture behavioral of fcs_check_serial is
  signal R,T           : std_logic_vector(31 downto 0);
  signal shift_count : unsigned(4 downto 0);
  signal data        : std_logic;
begin

  process (shift_count, start_of_frame, data_in, clk)
  begin
    data <= data_in;

    if shift_count < 31 or start_of_frame = '1' or end_of_frame = '1' then
      data <= not data_in;
    end if;
  end process;

  process(clk, reset, R, data)
  begin
    if reset = '1' then
      R           <= (others => '0');
      T           <= (others => '0');
      shift_count <= (others => '0');
      fcs_error   <= '1';
    elsif rising_edge(clk) then
      if start_of_frame = '1' then
        shift_count <= (others => '0');
      elsif end_of_frame = '1' then
        shift_count <= "00001";
      elsif shift_count < 31 then
        shift_count <= shift_count + 1;
      end if;

      -- Shift R

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

      T <= T(T'length - 2 downto 0) & data;

    end if;
  end process;

end behavioral;
