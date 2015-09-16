library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity env is
  port (clk   : in  std_logic;              -- The clock signal.
        reset : in  std_logic;              -- Reset the module.
        req   : out std_logic;              -- Start computation.
        AB    : out unsigned(7 downto 0);   -- The two operands. One at at time
        ack   : in  std_logic;              -- Computation is complete.
        C     : in  unsigned(7 downto 0));  -- The result.
end env;

architecture behavioral of env is
begin
  process (data_in, ack)
    -- Read inputs from file.
    --type operands is array (0 to 4) of natural;
    --variable a_operants  : operands := (91, 17, 49, 81, 25);
    --variable b_operants  : operands := (63, 11, 98, 45, 5);
    --variable c_results   : operands := (7, 1, 49, 9, 5);
    variable test_number : integer := 0;
  begin
    -- GCD example. Change this for fcs_check_serial.
    -- data_in <= test_data
    -- wait clock * bleh ns
    -- assert fcs_error
    case current_state is
      when INPUT_A =>
        req <= '1';
        AB  <= TO_UNSIGNED(a_operants(test_number), AB'length);
                                        -- The a operant is converted to a std_logic_vector

        if ack = '0' then               -- wait until finish signal ack is one
          next_state <= INPUT_A;
        else                            -- then set next_state to DONE
          next_state <= DONE_A;
        end if;

      when DONE_A =>
        req <= '0';                     -- Phase 3 of handshaking protocol.
        AB  <= (others => 'X');         -- remove A

        if ack = '1' then               -- wait until GCD module finishes the
          next_state <= DONE_A;         -- handshake protocol,
        else                            -- then start a new computation.
          next_state <= INPUT_B;
        end if;

      when INPUT_B =>
        req  <= '1';
        AB   <= TO_UNSIGNED(b_operants(test_number), AB'length);
                                        -- The b operant is converted to a std_logic_vector
        ld_R <= '1';                    -- Enable result register.

        if ack = '0' then               -- wait until finish signal ack is one
          next_state <= INPUT_B;
        else                            -- then set next_state to DONE
          next_state <= DONE_ALL;
        end if;

      when DONE_ALL =>
        req  <= '0';                    -- Phase 3 of handshaking protocol.
        AB   <= (others => 'X');        -- remove B
        ld_R <= '0';                    -- Disable result register.
        assert R = TO_UNSIGNED(c_results(test_number), C'length) report "Wrong result!" severity failure;
        if ack = '1' then               -- wait until GCD module finishes the
          next_state <= DONE_ALL;       -- handshake protocol,
        else                            -- then start a new computation.
          if test_number < 4 then
            test_number := test_number + 1;
          else
            test_number := 0;
            report "Test passed" severity failure;
          end if;
          next_state <= INPUT_A;
        end if;

    end case;
  end process;

  -- This process assigns next_state to current_state. It implements the
  -- state holding registers in the statemachine.
  process(clk)
  begin
    if rising_edge(clk) then
      if ld_R = '1' then
        R <= C;
      end if;

      if reset = '1' then
        current_state <= INPUT_A;       -- Reset to initial state
      else
        current_state <= next_state;    -- go to next_state
      end if;
    end if;
  end process;
end behavioral;
