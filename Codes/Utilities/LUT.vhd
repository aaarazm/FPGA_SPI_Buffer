library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LUT is
generic(DataWidth : integer := 16);
port(
	sel : in std_logic_vector(2 downto 0);
	
	data : out std_logic_vector((DataWidth - 1) downto 0)-- Two different methods of making a mux.
	); 
end entity;

architecture rtl of LUT is
	
begin

	process(sel) is
	begin
	
		case sel is
			when "000" =>
				data <= "0000000000000000";
			when "001" =>
				data <= "0000000000000001";
			when "010" =>
				data <= "0000000000000010";
			when "011" =>
				data <= "0000000000000100";
			when "100" =>
				data <= "0000000000001000";
			when "101" =>
				data <= "0000000000010000";
			when "110" =>
				data <= "0000000000100000";
			when "111" =>
				data <= "0000000001000000";
			when others =>
				data <= (others => 'Z');
		end case;
		
	end process;
	
end architecture;