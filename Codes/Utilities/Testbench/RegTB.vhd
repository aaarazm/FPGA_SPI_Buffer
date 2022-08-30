library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegTB is
end entity;

architecture sim of RegTB is

	constant width : integer := 16;
	constant period : time := 4 ns;
	
	signal clkk :  std_logic := '0';
	signal rstt :  std_logic := '1';
	signal ldd :  std_logic := '0';
    signal dd : std_logic_vector((width - 1) downto 0) := "1100110000111100";
    signal qq : std_logic_vector((width - 1) downto 0);

begin

	SPI_M : entity work.Reg(rtl)
	generic map (DataWidth => width)
	port map -- Instantiation of SPI_Master inside testbench.
	(
        clk     => clkk,
        rst => rstt,
        ld  => ldd,
        D  => dd,
        Q  => qq
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
        wait for 3 ns;
        rstt <= '1';
        wait for 4 ns;
        ldd <= '1';
        wait for 8 ns;
        dd <= "1111000011000011";
        wait for 3 ns;
        ldd <= '0';
        wait for 5 ns;
        dd <= "1111111111111111";
        wait for 4 ns;
        ldd <= '1';
        wait for 8 ns;
        rstt <= '0';
        wait for 1 ns;
        rstt <= '1';
        wait;

	end process;
	
end architecture;