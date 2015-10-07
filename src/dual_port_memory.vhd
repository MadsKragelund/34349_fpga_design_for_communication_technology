library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

-- Dual port memory ENTITY
entity dual_port_memory is
	generic(
         n : integer
	);
	port(
		wclk           : in std_logic;
		rclk           : in std_logic;
		raddr				: in std_logic_vector(n downto 0);
		ren				: in std_logic;
		waddr				: in std_logic_vector(n downto 0);
		wen				: in std_logic;
		write_data_in  : in std_logic_vector(n downto 0);
		read_data_out  : out std_logic_vector(n downto 0)
	);
end dual_port_memory;

architecture arch of dual_port_memory is
begin

end arch;