library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity motor_control is
port ( 
	clk        : in std_logic;	--时钟为秒级
	rst        : in std_logic;
	
	pattern    : in std_logic_vector(1 downto 0);
	
	ticking    : out std_logic;

	motor      : out std_logic_vector(1 downto 0);
	leds       : out std_logic_vector(2 downto 0)
);
end motor_control;

architecture Behavioral of motor_control is

begin

	process(clk, rst)
	type motor_state is(forward, reverse, pause);
	variable current_state : motor_state := forward;
	variable wash_time : integer := 0;
	variable temp : integer := 0;
	begin
		if(falling_edge(rst)) then --复位
			temp := 0;
			wash_time := 0;
			motor <= "00";
			leds <= "000";
			ticking <= '0';
		elsif(rising_edge(clk)) then	
			ticking <= '0';
			leds <= "000";
			motor <= "00";
			if(pattern = "01") then	--初始化中
				temp := temp + 1;
				motor <= "00";
				ticking <= '0';
				if(temp = 10) then	--led进行三次闪烁
					temp := 0;
					leds <= "111";
				end if;
			elsif(pattern = "10") then	--工作中
				wash_time := wash_time + 1;	--洗涤时间改变
				if(wash_time = 60) then
					wash_time := 0;
					ticking <= '1';
				end if;
				temp := wash_time / 10;	--洗涤时间除以10，来获取当前状态
				if(temp = 0 or temp = 1) then
					current_state := forward; --正转
				elsif(temp = 2) then
					current_state := pause;	--暂停
				elsif(temp = 3 or temp = 4) then
					current_state := reverse;	--反转
				elsif(temp = 5) then
					current_state := pause;	--暂停
				end if;
				
				case current_state is
					when forward =>  motor <= "10"; leds <= "100"; --正转时
					when reverse =>  motor <= "01"; leds <= "010"; --反转时
					when pause   =>  motor <= "00"; leds <= "001"; --暂停时
				end case;
			end if;
		end if;
	end process;


end Behavioral;

