LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY adcReceiveBufferCtrl IS
--  GENERIC(
--    data_length : INTEGER := 16);     --data length in bits
  PORT(
    clk, reset, mBusy, DRDYBar, ss_n      : IN     STD_LOGIC;
    CSBar, enable, ld_a, ld_b, ld_c, ld_d : OUT    STD_LOGIC;
    address                               : OUT    STD_LOGIC_VECTOR(2 DOWNTO 0));
END adcReceiveBufferCtrl;

ARCHITECTURE behavioural OF adcReceiveBufferCtrl IS
  TYPE FSM IS(idle, execute);                    --state machine
  SIGNAL pState, nState : FSM;
  SIGNAL CS_toggle      : STD_LOGIC := '1';
  SIGNAL clk_toggles    : INTEGER RANGE 0 TO 5;  --clock toggle counter


BEGIN
  
  CSBar <= CS_toggle;
  PROCESS(pState, mBusy, DRDYBar, ss_n) IS
  BEGIN
    ld_a <= '0';
    ld_b <= '0';
    ld_c <= '0';
    ld_d <= '0';
    enable <= '0';
    address <= "000";

    CASE pState IS

      WHEN idle =>					 -- bus is idle
        CS_toggle <= '1';
        clk_toggles <= 0;
  
        IF(DRDYBar = '0') THEN       		--initiate communication
          --CSBar <= '0';
          enable <= '1';

          nState <= execute;
        ELSE
          enable <= '0';
          nState <= idle;          
        END IF;


      WHEN execute =>
        enable <= '1';
        IF falling_edge(ss_n) and clk_toggles = 0 THEN
          CS_toggle <= '0';
        END IF;
        
		    -- counter
		    IF mBusy = '0' THEN
          CASE clk_toggles IS
            WHEN 1 =>
              ld_a <= '1';
              address <= "001";
            WHEN 2 =>
              ld_b <= '1';
              address <= "010";
            WHEN 3 =>
              ld_c <= '1';
              address <= "011";
            WHEN 4 =>
              ld_d <= '1';
              address <= "100";
            WHEN others =>
              --do nothing
          END CASE;
          IF clk_toggles < 5 THEN
			      clk_toggles <= clk_toggles + 1; -- counting up
            nState <= execute;
          ELSE -- if clk_toggle reached the limit
            nState <= idle;
          END IF;
        END IF;

    END CASE;
  END PROCESS;

  PROCESS(clk, reset) IS
  BEGIN
    IF falling_edge(clk) or falling_edge(reset) THEN
      IF reset = '0' THEN
        pState <= idle;
      ELSE
        pState <= nState;
      END IF;
    END IF;
  END PROCESS;

END behavioural;