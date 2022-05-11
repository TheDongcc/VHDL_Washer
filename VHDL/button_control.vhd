library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity button_control is
port(
	clk 			: in std_logic := '0';
	rst   			: in std_logic := '0';
	
	time_up_in 		: in std_logic := '0';
	time_down_in 	: in std_logic := '0';
	stop_in 		: in std_logic := '0';
	start_in 		: in std_logic := '0';
	
	time_up_out 	: out std_logic := '0';
	time_down_out 	: out std_logic := '0';
	
	pattern 		: out std_logic_vector(1 downto 0);
	
	buzzer 			: out std_logic := '0'
);
end button_control;

architecture Behavioral of button_control is
begin
	process(clk, rst)
	type states is (waiting, initial, working, interrupt);--未开始，初始化，工作中，暂停中
	variable current_state : states := waiting;--             00    01     10     11
	variable initial_timer : integer := 0;
	variable temp : integer := 0;
	begin
		if(falling_edge(rst)) then	--复位
		    current_state := waiting;
			temp := 0;
			pattern <= "00";
			buzzer <= '0';
			time_up_out <= '0';
			time_down_out <= '0';
		elsif(rising_edge(clk)) then 
			if(current_state = waiting) then --未开始状态
			    pattern <= "00";			
				if(temp < 11) then			--上电后蜂鸣器连续鸣叫
					if((temp rem 2) = 1) then
						buzzer <= '1';
					elsif((temp rem 2) = 0) then
						buzzer <= '0';
					end if;
					temp := temp + 1;
				end if;
				
				time_up_out <= '0';
				time_down_out <= '0';
				if(start_in = '1') then		--开始按钮按下
					buzzer <= '1';
					pattern <= "01";
					current_state := initial; --进入初始化状态
				elsif(time_up_in = '1') then	--时间增加按下
					buzzer <= '1';
					time_up_out <= '1';
				elsif(time_down_in = '1') then	--时间减少按下
					buzzer <= '1';
					time_down_out <= '1';
				end if;
				
			elsif(current_state = initial) then	--初始化状态
				buzzer <= '0';
				time_up_out <= '0';
				time_down_out <= '0';
				initial_timer := initial_timer + 1;
				if((initial_timer rem 10) = 0) then	--初始化时，每过一秒蜂鸣器响一次
					buzzer <= '1';
				end if;				
				if(initial_timer >= 30) then   --根据验证所需修改计时值，这里定义30个时钟周期为3秒

					initial_timer := 0;
					current_state := working;
					pattern <= "10";
					
				end if;
			elsif(current_state = working) then	--自动洗涤状态
				buzzer <= '0';
				time_up_out <= '0';
				time_down_out <= '0';
				if(stop_in = '1') then	--进入中断状态
					buzzer <= '1';
					current_state := interrupt;
					pattern <= "11";
				end if;
			elsif(current_state = interrupt) then --中断状态
				buzzer <= '0';
				time_up_out <= '0';
				time_down_out <= '0';
				if(start_in = '1') then
					buzzer <= '1';
					current_state := working;	--进入工作状态继续洗涤
					pattern <= "10";
				elsif(stop_in = '1') then
					buzzer <= '1';
					current_state := waiting; --结束洗涤，进入未开始状态
					pattern <= "00";
				elsif(time_up_in = '1') then	--中断状态可对时间进行改变
					buzzer <= '1';
					time_up_out <= '1';
				elsif(time_down_in = '1') then
					buzzer <= '1';
					time_down_out <= '1';
				end if;
			end if;
		end if;
	end process;

end Behavioral;
