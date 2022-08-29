LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY adcReceiveBufferCtrl IS
--  GENERIC(
--    data_length : INTEGER := 16);     --data length in bits
  PORT(
    clk, reset, mBusy, DRDYBar            : IN     STD_LOGIC;
    CSBar, enable, ld_a, ld_b, ld_c, ld_d : OUT    STD_LOGIC;
    address                               : OUT    STD_LOGIC_VECTOR(2 DOWNTO 0));
END adcReceiveBufferCtrl;

ARCHITECTURE behavioural OF adcReceiveBufferCtrl IS
  TYPE FSM IS(idle, execute);                    --state machine
  SIGNAL pState, nState : FSM;
  SIGNAL clk_toggles    : INTEGER RANGE 0 TO 5;  --clock toggle counter


BEGIN
  
  PROCESS(pState, mBusy, DRDYBar) IS
  BEGIN
    ld_a <= '0';
    ld_b <= '0';
    ld_c <= '0';
    ld_d <= '0';
    enable <= '0';
    address <= "000";
    CSBar <= '1';

    CASE state IS               

      WHEN init =>					 -- bus is idle

        clk_toggles <= '0';
  
        IF(DRDYBar = '0') THEN       		--initiate communication
          CSBar <= '0';
          enable <= '1';

          nState <= execute;        
        ELSE
          nState <= init;          
        END IF;


      WHEN execute =>
        CSBar <= '0';
        enable <= '1';
        
		    -- counter
		    IF(falling_edge(mBusy)) THEN
          CASE clk_toggles IS
            WHEN 1 =>
              ld_a <= '1';
            WHEN 2 =>
              ld_b <= '1';
            WHEN 3 =>
              ld_c <= '1';
            WHEN 4 =>
              ld_d <= '1';
          END CASE;
          IF clk_toggles < 5 THEN
			      clk_toggles <= clk_toggles + 1;
          END IF;
        END IF;
        IF clk_toggles = 5

    END CASE;
  END PROCESS;

END behavioural;