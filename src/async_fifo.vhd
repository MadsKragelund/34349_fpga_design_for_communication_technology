library ieee;
use work.all;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

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

	signal wsync          : std_logic := '0';
	signal rsync          : std_logic := '0';
	signal full           : std_logic := '0';
	signal empty			 : std_logic := '0';
	signal wen				 : std_logic := '0';
	signal ren				 : std_logic := '0';
	signal wptr    	    : std_logic_vector(15 downto 0);
	signal rptr    	    : std_logic_vector(15 downto 0);
	signal waddr   		 : std_logic_vector(4 downto 0);
	signal raddr          : std_logic_vector(4 downto 0);
	
	-- FIFO Control
	component fifo_control is
		port(
			clk 				: in std_logic; 
			reset				: in std_logic;
			enable			: in std_logic;
			sync				: in std_logic;
			pointer			: out std_logic_vector(15 downto 0);
			fifo_occu		: out std_logic_vector(4 downto 0);
			flag				: out std_logic;
			address			: out std_logic_vector(4 downto 0);
			en					: out std_logic
		);
	end component;
	
	-- SYNC Control
	component sync_control is
		port(
			clk	: in std_logic;
			ptr	: in std_logic_vector(15 downto 0);
			sync 	: out std_logic
		);
	end component;
	
	-- Dual port memory
	component dual_port_memory is
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
	end component;
	 
begin
	-- FIFO Write Control port mapping
	fwc : fifo_control
    port map(
		clk 				=> wclk,
		reset				=> reset,
		enable			=> write_enable,
		sync				=> wsync,
		pointer			=> wptr,
		fifo_occu		=> fifo_occu_in,
		flag				=> full,
		address			=> waddr,
		en					=> wen
	 );
	 
	-- FIFO Read Control port mapping
	frc : fifo_control
    port map(		
		clk 				=> rclk,
		reset				=> reset,
		enable			=> read_enable,
		sync				=> rsync,
		pointer			=> rptr,
		fifo_occu		=> fifo_occu_out,
		flag				=> empty,
		address			=> raddr,
		en					=> ren
	 );
	 
	-- SYNC Read Control port mapping
	ws : sync_control
    port map(		
		clk	=> wclk,
		ptr	=> wptr,
		sync 	=> wsync
	);
	 
	-- SYNC Read Control port mapping
	rs : sync_control
    port map(		
		clk	=> rclk,
		ptr	=> rptr,
		sync 	=> rsync
	);
	
	-- Dual port memory port mapping
	dpm : dual_port_memory
    port map(		
		wclk           => wclk,
		rclk           => rclk,
		waddr				=> waddr,
		raddr				=> raddr,
		wen				=> wen,
		ren				=> ren,
		write_data_in  => write_data_in,
		read_data_out  => read_data_out
	);


  process (wclk)
  begin
    -- COMBINATORIC PROCESS
  end process;

  process(wclk, reset)
  begin
	 -- CLOCK PROCESS
    if reset = '1' then
      -- reset the system
    elsif rising_edge(wclk) then
      --
	 else
	 -- do nothing
    end if;
  end process;

end arch;
