library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity washer_top is
Port ( 
	clk 			: in std_logic;
	rst 			: in std_logic;
	time_up_in 		: in std_logic;
	time_down_in 	: in std_logic;
	start 			: in std_logic;
	stop 			: in std_logic;
	
	buzzer 			: out std_logic;
	motor 			: out std_logic_vector(1 downto 0);
	leds 			: out std_logic_vector(2 downto 0);
	segment 		: out std_logic_vector(7 downto 0)
);
end washer_top;

architecture Behavioral of washer_top is

component second_generater is 	--分频器模块
port(
	clk 	: in std_logic;
	rst 	: in std_logic;
	second  : out std_logic
);
end component;

component button_control is 	--按键控制模块
port(
	clk 			: in std_logic;
	rst 			: in std_logic;
	
	time_up_in 		: in std_logic;
	time_down_in 	: in std_logic;
	stop_in 		: in std_logic;
	start_in 		: in std_logic;
	
	time_up_out 	: out std_logic;
	time_down_out 	: out std_logic;
	
	pattern 		: out std_logic_vector(1 downto 0);
	
	buzzer 			: out std_logic
);
end component;

component timer is --计时器模块
port(
	
	clk 				: in std_logic;
	rst 				: in std_logic;
	
	time_down_second 	: in std_logic;
	time_up 			: in std_logic;
	time_down 			: in std_logic;
	
	reset 				: buffer std_logic;
	pattern 			: in std_logic_vector(1 downto 0);
	seg_transmit 		: out std_logic_vector(6 downto 0)
);
end component;

component motor_control is 		--电机控制模块
port ( 
	clk 		: in std_logic;
	rst 		: in std_logic;

	pattern 	: in std_logic_vector(1 downto 0);
	ticking 	: out std_logic;
	motor 		: out std_logic_vector(1 downto 0);
	leds 		: out std_logic_vector(2 downto 0)
);
end component;

component segment_control is 		--数码管驱动模块
Port ( 
	clk 		: in std_logic;
	rst 		: in std_logic;
	time_in 	: in std_logic_vector(6 downto 0);
	seg_control : out std_logic_vector(7 downto 0)
);
end component;

signal time_up      : std_logic;
signal time_down    : std_logic;
signal ticking      : std_logic;
signal pattern      : std_logic_vector(1 downto 0);
signal second       : std_logic;
signal segBus       : std_logic_vector(6 downto 0);
signal reset        : std_logic;

begin 							--开始

second_generater_0 : second_generater 	--分频器模块例化
port map(
	clk 	=> clk ,
	rst 	=> reset,
	second  => second
);

button_control_0 : button_control		--按键控制模块例化
port map(
	clk 			=> clk 		,	
	rst   			=> reset   	,		
                
	time_up_in 		=> time_up_in ,		
	time_down_in 	=> time_down_in ,	
	stop_in 		=> stop 	,	
	start_in 		=> start 	,	
	                   
	time_up_out 	=> time_up 	,
	time_down_out 	=> time_down ,	
	                   
	pattern 		=> pattern 	,	
	                   
	buzzer 			=> buzzer 		
	
);

timer_0 : timer					--计时器模块例化
port map(
	clk 			 => clk 	 ,		
	rst 			 => reset 	 ,		
	                    
	time_down_second => ticking ,
	time_up 		 => time_up 	 ,	
	time_down 		 => time_down 	 ,	
	                    
	reset 			 => reset 		 ,	
	pattern 		 => pattern  ,		
	seg_transmit 	 => segBus  	
);

motor_control_0 : motor_control 	--电机控制模块例化
port map(
	clk 	=>	clk 	,
	rst 	=>	reset 	,
           
	pattern =>	pattern ,
	ticking =>	ticking ,
	motor 	=>	motor 	,
	leds 	=>	leds 		
);

segment_control_0 : segment_control	--数码管控制模块例化
port map(
	clk 		=>	clk 	,	
	rst 		=>  reset 	,	
	time_in 	=>  segBus 	,
	seg_control =>  segment
);

end Behavioral;
