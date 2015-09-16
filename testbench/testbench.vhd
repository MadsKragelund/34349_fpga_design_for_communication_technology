library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture structure of testbench is
  component clock
    generic (period :     time      := 10 ns);
    port (clk       : out std_logic := '0');
  end component;

  component environment
    port (clk   : in  std_logic;              -- The clock signal.
          reset : in  std_logic;              -- Reset the module.
          req   : out std_logic;              -- Start computation.
          AB    : out unsigned(7 downto 0);   -- The two operands.
          ack   : in  std_logic;              -- Computation is complete.
          C     : in  unsigned(7 downto 0));  -- The result.
  end component;

  component fcs_check_serial
  port (clk            : in  std_logic;   -- system clock
        reset          : in  std_logic;   -- asynchronous reset
        start_of_frame : in  std_logic;   -- arrival of the first bit.
        end_of_frame   : in  std_logic;   -- arrival of the first bit in FCS.
        data_in        : in  std_logic;   -- serial input data.
        fcs_error      : out std_logic);  -- indicates an error.
  end component;

  signal req, ack, clk, reset : std_logic;             -- Signals to inter-
  signal AB, C                : unsigned(7 downto 0);  -- connect components.

begin
  -- assert reset, note that reset is active high
  reset <= '1', '0' after 110 ns;

  i_clock_1 : clock
    port map (clk);

  i_environment_1 : environment
    port map (clk, reset, req, AB, ack, C);

  i_fcs_check_serial_1 : fcs_check_serial
    port map (clk, reset, req, AB, ack, C);

end structure;
