LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY adcReceiveBuffer IS
--  GENERIC(
--    data_length : INTEGER := 16);     --data length in bits
  PORT(
    clk, reset, DRDYBar, Din           : IN     STD_LOGIC;
    CSBar, Dout, mosi, sclk : OUT    STD_LOGIC;
    A, B, C, D : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END adcReceiveBuffer;

ARCHITECTURE behavioural OF adcReceiveBuffer IS
    SIGNAL mBusy, enable, ld_a, ld_b, ld_c, ld_d : STD_LOGIC;
    SIGNAL address : STD_LOGIC_VECTOR(2 DOWNTO 0);


BEGIN

ControlUnit : entity work.adcReceiveBufferCtrl(behavioural)
port map
(
    clk     => clk,
    reset   => reset,
    mBusy   => mBusy,
    DRDYBar => DRDYBar,
    CSBar   => CSBar,
    enable  => enable,
    ld_a    => ld_a,
    ld_b    => ld_b,
    ld_c    => ld_c,
    ld_d    => ld_d,
    address => address                           
);

Datapath : entity work.adcReceiveBufferDp(rtl)
generic map (data_length => 16)
port map
(
    clk     => clk,
    reset_n => reset,
    enable  => enable,
    ld_a    => ld_a,
    ld_b    => ld_b,
    ld_c    => ld_c,
    ld_d    => ld_d,
    address => address,
    Din     => Din,
    Dout    => Dout,
    sclk    => sclk,
    busy    => mBusy,
    a       => A,
    b       => B,
    c       => C,
    d       => D
);
END behavioural;