library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

-- FIFO Control ENTITY
entity fifo_control is
	port(
		clk 				: in std_logic; 
		reset				: in std_logic;
		enable			: in std_logic;
		sync				: in std_logic;
		pointer			: out std_logic;
		fifo_occu		: out std_logic_vector(4 downto 0);
		flag				: out std_logic;
		address			: out std_logic_vector(4 downto 0);
		en					: out std_logic
	);
end fifo_control;

architecture arch of fifo_control is
begin

end arch;