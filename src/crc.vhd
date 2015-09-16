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
