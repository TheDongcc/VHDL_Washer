library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity segment_control is
Port ( 
	clk            : in std_logic;
	rst            : in std_logic;
	time_in        : in std_logic_vector(6 downto 0);
	seg_control    : out std_logic_vector(7 downto 0)
);
end segment_control;

architecture Behavioral of segment_control is
signal display_value : integer := CONV_INTEGER(time_in);	--将逻辑向量转换为整型数字
begin
	process(clk)
	begin
	display_value <= CONV_INTEGER(time_in);
	if(falling_edge(rst)) then
		seg_control(7 downto 0) <= "00110000";	--默认显示为30分钟
	elsif(rising_edge(clk)) then
			case display_value / 10 is		--数码管的十位
				when 0 => seg_control(7 downto 4) <= "0000";
				when 1 => seg_control(7 downto 4) <= "0001";
				when 2 => seg_control(7 downto 4) <= "0010";
				when 3 => seg_control(7 downto 4) <= "0011";
				when 4 => seg_control(7 downto 4) <= "0100";
				when 5 => seg_control(7 downto 4) <= "0101";
				when 6 => seg_control(7 downto 4) <= "0110";
				when 7 => seg_control(7 downto 4) <= "0111";
				when 8 => seg_control(7 downto 4) <= "1000";
				when 9 => seg_control(7 downto 4) <= "1001";
				when others => seg_control(7 downto 4) <= "0000";
			end case;
			case display_value rem 10 is	--数码管的个位
				when 0 => seg_control(3 downto 0) <= "0000";
				when 1 => seg_control(3 downto 0) <= "0001";
				when 2 => seg_control(3 downto 0) <= "0010";
				when 3 => seg_control(3 downto 0) <= "0011";
				when 4 => seg_control(3 downto 0) <= "0100";
				when 5 => seg_control(3 downto 0) <= "0101";
				when 6 => seg_control(3 downto 0) <= "0110";
				when 7 => seg_control(3 downto 0) <= "0111";
				when 8 => seg_control(3 downto 0) <= "1000";
				when 9 => seg_control(3 downto 0) <= "1001";
				when others => seg_control(3 downto 0) <= "0000";
			end case;			
	end if;
	end process;

end Behavioral;
