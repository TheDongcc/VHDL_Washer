library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity timer is
port(
	clk 				: in std_logic;
	rst 				: in std_logic;
	
	time_down_second 	: in std_logic;
	time_up 			: in std_logic;
	time_down 			: in std_logic;
	pattern 			: in std_logic_vector(1 downto 0);
	
	seg_transmit 		: out std_logic_vector(6 downto 0);
	reset 				: buffer std_logic
);
end timer;
architecture Behavioral of timer is
constant time_default : std_logic_vector(6 downto 0) := "0011110";		--默认时间，定义为30分钟
begin
	process(clk, rst, time_down_second)
	variable time_set : std_logic_vector(6 downto 0) := time_default;	--显示时间
	variable count_down : std_logic_vector(6 downto 0) := "0000011";	--初始化使用的倒计时时间
	variable temp : integer := 0;
	begin
		if(falling_edge(rst)) then
			seg_transmit <= "0011110";
			time_set := time_default;	
			count_down := "0000011";
			temp := 0;
			reset <= '1';
		elsif(rising_edge(clk)) then

			if(pattern = "00" or pattern = "11") then --未开始、暂停中，两种状态都可通过按键改变时间
			    reset <= '1';
				if(time_up = '1') then
					time_set := time_set + '1';
				elsif(time_down = '1') then
					time_set := time_set - '1';
				end if;
				
				if(time_set > "1100011") then
					time_set := "0000000";
				end if;
				
				if(time_set <= "0000000") then
					time_set := "1100011";
				end if;
				
				seg_transmit <= time_set;
	
			elsif(pattern = "01") then   --初始化，不可通过按键改变时间，但是会自动通过计时改变时间
			    reset <= '1';
			    temp := temp + 1;
			    seg_transmit <= count_down;
			    if(temp = 10) then
			         temp := 0;
			         count_down := count_down - '1';	         
			    end if;
			    
			elsif(pattern = "10") then     --工作中，工作时每当由电机驱动模块发出的一分钟结束信号到来，会将数码管计数-1
				
			    seg_transmit <= time_set;
			    if(time_down_second = '1' and reset = '1') then
					time_set := time_set - '1';
			    end if;
			    
			    if(time_set <= "0000000") then	--当定时时间到达时，发出复位信号，对真个电路进行复位
				    reset <= '0';				--reset连接到系统复位rst上
				end if;
				
			end if;	 
		end if;

	end process;

end Behavioral;
