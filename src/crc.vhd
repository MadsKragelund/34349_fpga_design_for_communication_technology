entity fcs_check_serial is
  port (
    clk            : in  std_logic;     -- system clock
    reset          : in  std_logic;     -- asynchronous reset
    start_of_frame : in  std_logic;     -- arrival of the first bit.
    end_of_frame   : in  std_logic;     -- arrival of the first bit in FCS.
    data_in        : in  std_logic;     -- serial input data.
    fcs_error      : out std_logic     -- indicates an error.
    );
end fcs_check_serial;

architecture behavioral of fcs_check_serial is
  signal R : std_logic_vector(31 downto 0);
begin
  process(start_of_frame)
  begin

  end

  process(end_of_frame)
  begin
    if (unsigned(R) = 0) and end_of_frame then
      fcs_error = 1;
    end;
  end
end behavioral;
