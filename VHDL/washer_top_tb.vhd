library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity washer_top_tb is
--  Port ( );
end washer_top_tb;

architecture Behavioral of washer_top_tb is
component washer_top is
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
end component;

signal clk 				: std_logic := '0';
signal rst 				: std_logic := '0';
signal time_up_in 		: std_logic := '0';
signal time_down_in 	: std_logic := '0';
signal start 			: std_logic := '0';
signal stop 			: std_logic := '0';

signal buzzer 			: std_logic := '0';
signal motor 			: std_logic_vector(1 downto 0) := "00";
signal leds 			: std_logic_vector(2 downto 0) := "000";
signal segment 			: std_logic_vector(7 downto 0) := "00000000";
constant ClockPeriod 	: time := 20 ns;

begin
washer_top_0 : washer_top
port map(
	clk 		 => clk 	,	
	rst 		 => rst ,		
	time_up_in 	 => time_up_in ,	
	time_down_in => time_down_in,
	start 		 => start 	,	
	stop 		 => stop 	,	
	                
	buzzer 		 => buzzer 	,	
	motor 		 => motor 	,	
	leds 		 => leds 	,	
	segment 	 => segment 
);
	rst <= '1', '0' after 10ns, '1' after 20ns;
	PROCESS
    begin
    clk <= '0';
    wait for ClockPeriod / 2;
    clk <= '1';
    wait for ClockPeriod / 2;
    end process;
	
	--time_up_in <= '0', '1'after 40ns, '0'after 60ns;
	
	start <= '0', '1'after 440ns, '0'after 460ns,'1' after 13600ns,'0'after 13620ns; --进入开始状态、再次进入洗涤状态
	--start <= '0', '1'after 40ns, '0'after 60ns,'1' after 12530ns, '0'after 12550ns; 
	stop <= '0', '1' after 12260ns, '0'after 12280ns;			--暂停洗涤状态，进入中断
	time_down_in <= '0', '1' after 12400ns, '0'after 12420ns;	--在中断中对时间进行减操作
	time_up_in <= '0', '1'after 12600ns, '0'after 13400ns;		--在中断中对时间进行加操作
	
end Behavioral;
