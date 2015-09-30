library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

-- SYNC ENTITY
entity sync_control is
	port(
		clk	: in std_logic;
		ptr	: in std_logic;
		sync 	: out std_logic;
	);
end sync_control;

architecture arch of sync_control is
  -- do something
end arch;