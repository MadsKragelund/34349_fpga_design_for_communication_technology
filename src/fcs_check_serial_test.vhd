library ieee;
use ieee.std_logic_1164.all;

-- uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
--use ieee.numeric_std.all;

entity fcs_check_serial_test is
end fcs_check_serial_test;

architecture behavior of fcs_check_serial_test is
  -- component declaration for the unit under test (uut)
  component fcs_check_serial
    port(
      clk            : in  std_logic;
      reset          : in  std_logic;
      start_of_frame : in  std_logic;
      end_of_frame   : in  std_logic;
      data_in        : in  std_logic;
      fcs_error      : out std_logic
      );
  end component;

  --inputs
  signal clk            : std_logic := '0';
  signal reset          : std_logic := '0';
  signal start_of_frame : std_logic := '0';
  signal end_of_frame   : std_logic := '0';
  signal data_in        : std_logic := '0';

  --outputs
  signal fcs_error : std_logic;

  -- clock period definitions
  constant clk_period      : time := 10 ns;
  constant data_to_send_in : std_logic_vector(511 downto 0) :=
    x"00_10_A4_7B_EA_80_00_12_34_56_78_90_08_00_45_00_00_2E_B3_FE_00_00_80_11" &
    x"05_40_C0_A8_00_2C_C0_A8_00_04_04_00_04_00_00_1A_2D_E8_00_01_02_03_04_05" &
    x"06_07_08_09_0A_0B_0C_0D_0E_0F_10_11_E6_C5_3D_B2";
  -- '11100110'
  -- '11000101'
  -- '00111101'
  -- '10110010'

begin
  -- instantiate the unit under test (uut)
  uut : fcs_check_serial port map (
    clk            => clk,
    reset          => reset,
    start_of_frame => start_of_frame,
    end_of_frame   => end_of_frame,
    data_in        => data_in,
    fcs_error      => fcs_error
    );

  -- clock process definitions
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;


  -- stimulus process
  stim_proc : process
  begin
    -- reset the state
    reset          <= '1';
    wait for clk_period;
    reset          <= '0';

    -- start sending data, and indicate we are no longer at the start of the frame
    for i in 0 to 511 loop
      if i = 0 then
        start_of_frame <= '1';
      else
        start_of_frame <= '0';
      end if;

      data_in <= data_to_send_in(i);

      -- Start of last frame (32 bits)
      if i = 479 then
        end_of_frame <= '1';
      else
        end_of_frame <= '0';
      end if;

      wait for clk_period;
    end loop;

    wait;
  end process;

end;
