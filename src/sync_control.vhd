library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

-- SYNC ENTITY
entity sync_control is
	generic(
         n : integer
	);
	port(
		clk	: in std_logic;
		ptr	: in std_logic_vector(n downto 0);
		sync 	: out std_logic
	);
end sync_control;

architecture arch of sync_control is
begin

end arch;