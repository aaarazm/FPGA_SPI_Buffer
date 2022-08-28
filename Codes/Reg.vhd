library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
generic(
	DataWidth : integer := 16
	);
port(
	clk : in std_logic;
	rst : in std_logic; --Asynchronous active-low reset
	ld : in std_logic;
	D : in std_logic_vector((DataWidth - 1) downto 0);
	Q : out std_logic_vector((DataWidth - 1) downto 0)
	); 
end entity;

architecture rtl of Reg is
	signal reg : std_logic_vector((DataWidth - 1) downto 0);
begin

	
	process(clk, rst) is
	begin
		
		if rising_edge(clk) or falling_edge(rst) then
		
			if rst = '0' then
				reg <= (others => '0');
			elsif ld = '1' then
				reg <= D;
			end if;
			
		end if;
	
	end process;
	
	Q <= reg;
	
	
end architecture;