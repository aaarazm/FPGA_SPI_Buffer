library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adcReceiveBufferTB is
end entity;

architecture sim of adcReceiveBufferTB is

	constant width : integer := 16;
	constant period : time := 4 ns;
    
	signal clk :  std_logic := '0';
	signal rst :  std_logic := '1';
	signal mosi :  std_logic;
	signal miso :  std_logic;
	signal sclk :  std_logic;
    signal DRDYBar : std_logic := '1';
    signal CSBar : std_logic;
    signal sBusy : std_logic;
    signal rx_enable : std_logic := '1';
    signal Tx : std_logic_vector((width - 1) downto 0) := "0011010100110101";
    signal Rx : std_logic_vector((width - 1) downto 0);
    signal A : std_logic_vector((width - 1) downto 0);
    signal B : std_logic_vector((width - 1) downto 0);
    signal C : std_logic_vector((width - 1) downto 0);
    signal D : std_logic_vector((width - 1) downto 0);

begin


    ReceiveBuffer : entity work.adcReceiveBuffer(behavioural)
    port map
    (
        clk     => clk,
        reset   => rst,
        DRDYBar => DRDYBar,
        Din     => miso,
        CSBar   => CSBar,
        Dout    => mosi,
        sclk    => sclk,
        A       => A,
        B       => B,
        C       => C,
        D       => D
    );

    Slave : entity work.spi_slave(behavioural)
    generic map(data_length => width)
    port map
    (
        reset_n   => rst,
        cpol      => '0',
        cpha      => '1',
        sclk      => sclk,
        ss_n      => CSBar,
        mosi      => mosi,
        miso      => miso,
        rx_enable => rx_enable,
        tx		  => Tx,
        rx		  => Rx,
        busy      => sBusy
    );

	process is
	begin
	
		wait for (period/2);
		clk <= not clk;
		
	end process;
	
	process is
	begin
		
		wait for 1 ns;
        rst <= '0';
        wait for 4 ns;
        rst <= '1';
        wait for 4 ns;
        DRDYBar <= '0';
        wait for 4 ns;
        DRDYBar <= '1';
        wait for 137 ns;
        Tx <= "0000000000000001";
        wait for 140 ns;
        Tx <= "0000000000000011";
        wait for 140 ns;
        Tx <= "0000000000000111";
        wait;

	end process;
	
end architecture;

--add wave -position insertpoint  \
--sim:/adcreceivebuffertb/clk \
--sim:/adcreceivebuffertb/rst \
--sim:/adcreceivebuffertb/mosi \
--sim:/adcreceivebuffertb/miso \
--sim:/adcreceivebuffertb/sclk \
--sim:/adcreceivebuffertb/DRDYBar \
--sim:/adcreceivebuffertb/CSBar \
--sim:/adcreceivebuffertb/sBusy \
--sim:/adcreceivebuffertb/rx_enable \
--sim:/adcreceivebuffertb/Tx \
--sim:/adcreceivebuffertb/Rx \
--sim:/adcreceivebuffertb/A \
--sim:/adcreceivebuffertb/B \
--sim:/adcreceivebuffertb/C \
--sim:/adcreceivebuffertb/D \
--sim:/adcreceivebuffertb/width \
--sim:/adcreceivebuffertb/period \
--sim:/adcreceivebuffertb/ReceiveBuffer/Datapath/SPI_M/ss_n \
--sim:/adcreceivebuffertb/ReceiveBuffer/ControlUnit/clk_toggles \
--sim:/adcreceivebuffertb/ReceiveBuffer/ControlUnit/pState \
--sim:/adcreceivebuffertb/ReceiveBuffer/ControlUnit/CS_toggle