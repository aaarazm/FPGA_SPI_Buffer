library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spiTB is
end entity;

architecture sim of spiTB is

	constant width : integer := 8;
	constant period : time := 4 ns;
	
	signal clkk :  std_logic := '0';
	signal rstt :  std_logic := '1';
	signal enablee :  std_logic := '1';
	signal cpoll :  std_logic := '1';
	signal cphaa :  std_logic := '1';
	signal mosii :  std_logic;
	signal misoo :  std_logic;
	signal ss_n1 :  std_logic;
	signal sclkk :  std_logic;
	signal mBusy :  std_logic;
	signal s1Busy :  std_logic;
	signal slave1RxEn :  std_logic;
    signal masterTx : std_logic_vector((width - 1) downto 0) := "10101011";
    signal slave1Tx : std_logic_vector((width - 1) downto 0) := "11001100";
    signal masterRx : std_logic_vector((width - 1) downto 0);
    signal slave1Rx : std_logic_vector((width - 1) downto 0);

begin

	SPI_M : entity work.spi_master(behavioural)
	generic map (data_length => width)
	port map -- Instantiation of SPI_Master inside testbench.
	(
        clk     => clkk,
        reset_n => rstt,
        enable  => enablee,
        cpol    => cpoll,
        cpha    => cphaa,
        miso    => misoo,
        sclk    => sclkk,
        ss_n    => ss_n1,
        mosi    => mosii,
        busy    => mBusy,
        tx		=> masterTx,
        rx	    => masterRx
	);

    SPI_S1 : entity work.spi_slave(behavioural)
    generic map (data_length => width)
    port map
    (
        reset_n   => rstt,
        cpol      => cpoll,
        cpha      => cphaa,
        sclk      => sclkk,
        ss_n      => ss_n1,
        mosi      => mosii,
        miso      => misoo,
        rx_enable => slave1RxEn,
        tx		  => slave1Tx,
        rx		  => slave1Rx,
        busy      => s1Busy
    );

	process is
	begin
	
		wait for (period/2);
		clkk <= not clkk;
		
	end process;
	
	process is
	begin
		
		wait for 1 ns;
        rstt <= '0';
        enablee <= '0';
        wait for 5 ns;
        rstt <= '1';
        wait for 4 ns;
        enablee <= '1';
        wait for 40 ns;
        enablee <= '0';
        slave1RxEn <= '1';
        masterTx <= "11110000";
        slave1Tx <= "11000011";
        wait for 50 ns;
        enablee <= '1';
        wait for 10 ns;
        enablee <= '0';
        wait;

	end process;
	
end architecture;