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
         clk : in  std_logic;
         reset : in  std_logic;
         start_of_frame : in  std_logic;
         end_of_frame : in  std_logic;
         data_in : in  std_logic;
         fcs_error : out  std_logic
        );
    end component;

   --inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start_of_frame : std_logic := '0';
   signal end_of_frame : std_logic := '0';
   signal data_in : std_logic := '0';

 	--outputs
   signal fcs_error : std_logic;

   -- clock period definitions
   constant clk_period : time := 10 ns;
   constant data_to_send_in : std_logic_vector(479 downto 0) := "000000000001000010100100011110111110101010000000000000000001001000110100010101100111100010010000000010000000000001000101000000000000000000101110101100111111111000000000000000001000000000010001000001010100000011000000101010000000000000101100110000001010100000000000000001000000010000000000000001000000000000000000000110100010110111101000000000000000000100000010000000110000010000000101000001100000011100001000000010010000101000001011000011000000110100001110000011110001000000010001";

begin
	-- instantiate the unit under test (uut)
   uut: fcs_check_serial port map (
          clk => clk,
          reset => reset,
          start_of_frame => start_of_frame,
          end_of_frame => end_of_frame,
          data_in => data_in,
          fcs_error => fcs_error
        );

   -- clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;


   -- stimulus process
   stim_proc: process
   begin
      -- reset the state
      reset <= '1';
      wait for clk_period;
      reset <= '0';
      wait for clk_period;
      -- start the frame
      start_of_frame <= '1';
      wait for clk_period;

      -- start sending data, and indicate we are no longer at the start of the frame
      start_of_frame <= '0';
      for i in 0 to 479 loop
        data_in <= data_to_send_in(i);
        wait for clk_period;
      end loop;

      -- end the frame
      end_of_frame <= '1';
      wait;
   end process;

end;
