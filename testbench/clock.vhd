library ieee;
use ieee.std_logic_1164.all;

entity fcs_clock is
  generic (period :    time := 10ns);
  port (clock     : in std_logic);
end fcs_clock;

architecture behavioral of fcs_clock is
begin
  process
  begin
    clock <= '1', '0' after period / 2;
    wait for period;
  end process;
end behavorial;
