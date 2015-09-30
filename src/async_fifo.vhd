library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

-- Dual port memory ENTITY
entity dual_port_memory is
	port(
		wclk           : in std_logic;
		rclk           : in std_logic;
		raddr				: in std_logic_vector(4 downto 0);
		ren				: in std_logic;
		waddr				: in std_logic_vector(4 downto 0);
		wen				: in std_logic;
		write_data_in  : in std_logic_vector(7 downto 0);
		read_data_out  : out std_logic_vector(7 downto 0)
);
end dual_port_memory;

architecture arch of dual_port_memory is
  -- do something
end arch;


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


-- FIFO Write Control ENTITY
entity fifo_write_control is
	port(
		wclk 				: in std_logic; 
		reset				: in std_logic;
		write_enable	: in std_logic;
		wsync				: in std_logic;
		wptr				: out std_logic_vector(4 downto 0);
		fifo_occu_in	: out std_logic_vector(4 downto 0);
		full				: out std_logic;
		waddr				: out std_logic_vector(4 downto 0);
		wen				: out std_logic
	);
end fifo_write_control;

architecture arch of fifo_write_control is
  -- do something
end arch;


-- FIFO Read Control ENTITY
entity fifo_read_control is
	port(
		rclk 				: in std_logic; 
		reset				: in std_logic;
		read_enable		: in std_logic;
		rsync				: in std_logic;
		rptr				: out std_logic_vector(4 downto 0);
		fifo_occu_out	: out std_logic_vector(4 downto 0);
		empty				: out std_logic;
		raddr				: out std_logic_vector(4 downto 0);
		ren				: out std_logic
	);
end fifo_read_control;

architecture arch of fifo_read_control is
  -- do something
end arch;



-- ASYNC_FIFO ENTITY
entity async_fifo is
  port ( 
    reset          : in std_logic;
    wclk           : in std_logic;
    rclk           : in std_logic;
    write_enable   : in std_logic;
    read_enable    : in std_logic;
    fifo_occu_in   : out std_logic_vector(4 downto 0);
    fifo_occu_out  : out std_logic_vector(4 downto 0);
    write_data_in  : in std_logic_vector(7 downto 0);
    read_data_out  : out std_logic_vector(7 downto 0)
  );
end async_fifo;


architecture arch of async_fifo is
	-- FIFO Write Control
	component fifo_write_control is
		port(
			wclk 				: in std_logic; 
			reset				: in std_logic;
			write_enable	: in std_logic;
			wsync				: in std_logic;
			wptr				: out std_logic_vector(4 downto 0);
			fifo_occu_in	: out std_logic_vector(4 downto 0);
			full				: out std_logic;
			waddr				: out std_logic_vector(4 downto 0);
			wen				: out std_logic
		);
	end component;
	
	-- FIFO Read Control
	component fifo_read_control is
		port(
			rclk 				: in std_logic; 
			reset				: in std_logic;
			read_enable		: in std_logic;
			rsync				: in std_logic;
			rptr				: out std_logic_vector(4 downto 0);
			fifo_occu_out	: out std_logic_vector(4 downto 0);
			empty				: out std_logic;
			raddr				: out std_logic_vector(4 downto 0);
			ren				: out std_logic
		);
  end component;
	 
begin
	-- FIFO Write Control port mapping
	fwc : fifo_write_control
    port map(
      wclk 				=> wclk,
		reset				=> reset,
		write_enabled	=> write_enable,
		wsync				=> wsync
	 );
	 
	-- FIFO Read Control port mapping
	frc : fifo_read_control
    port map(
      rclk 				=> rclk,
		reset				=> reset,
		read_enabled	=> read_enable,
		rsync				=> rsync
	 );


  process (shift_count, start_of_frame, data_in, clk)
  begin
    -- COMBINATORIC PROCESS
  end process;

  process(clk, reset, R, data)
  begin
	 -- CLOCK PROCESS
    if reset = '1' then
      -- reset the system
    elsif rising_edge(clk) then
      --
	 else
	 -- do nothing
    end if;
  end process;

end arch;
