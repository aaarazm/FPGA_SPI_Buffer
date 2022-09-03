LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY adcReceiveBufferDp IS
  GENERIC(
    data_length : INTEGER := 16);     --data length in bits
  PORT(
    clk, reset_n, enable, ld_a, ld_b, ld_c, ld_d : IN     STD_LOGIC;
    address                                      : IN     STD_LOGIC_VECTOR(2 DOWNTO 0);
    Din                                          : IN     STD_LOGIC;
    Dout                                         : OUT    STD_LOGIC;
    sclk                                         : OUT    STD_LOGIC;
    busy                                         : OUT    STD_LOGIC;
    ss_n                                         : OUT    STD_LOGIC;
    a, b, c, d                                   : OUT    STD_LOGIC_VECTOR(data_length-1 DOWNTO 0));
END adcReceiveBufferDp;

ARCHITECTURE rtl OF adcReceiveBufferDp IS
--  SIGNAL last_bit	: INTEGER RANGE 0 TO data_length*2;        --last bit indicator
  SIGNAL tx, rx	     	: STD_LOGIC_VECTOR(data_length-1 DOWNTO 0);  --data to transmit


BEGIN

SPI_M : entity work.spi_master(behavioural)
generic map (data_length => data_length)
port map -- Instantiation of SPI_Master inside testbench.
(
      clk     => clk,
      reset_n => reset_n,
      enable  => enable,
      cpol    => '0',
      cpha    => '1',
      miso    => Din,
      sclk    => sclk,
      ss_n    => ss_n,
      mosi    => Dout,
      busy    => busy,
      tx		  => tx,
      rx	    => rx
);

LUT_1 : entity work.LUT(rtl)
generic map (DataWidth => data_length)
port map
  (
    sel  => address,
    data => tx
  );

Reg_a : entity work.Reg(rtl)
generic map (DataWidth => data_length)
port map
  (
    clk => clk,
    rst => reset_n,
    ld  => ld_a,
    D   => rx,
    Q   => a
  );

Reg_b : entity work.Reg(rtl)
generic map (DataWidth => data_length)
port map
  (
    clk => clk,
    rst => reset_n,
    ld  => ld_b,
    D   => rx,
    Q   => b
  );

Reg_c : entity work.Reg(rtl)
generic map (DataWidth => data_length)
port map
  (
    clk => clk,
    rst => reset_n,
    ld  => ld_c,
    D   => rx,
    Q   => c
  );

Reg_d : entity work.Reg(rtl)
generic map (DataWidth => data_length)
port map
  (
    clk => clk,
    rst => reset_n,
    ld  => ld_d,
    D   => rx,
    Q   => d
  );
  
END rtl;
