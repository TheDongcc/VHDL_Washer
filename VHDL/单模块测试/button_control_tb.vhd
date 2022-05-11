library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity button_control_tb is
--  Port ( );
end button_control_tb;

architecture Behavioral of button_control_tb is
component button_control is
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
end component;

signal clk : std_logic;
signal rst : std_logic;

signal time_up_in : std_logic;
signal time_down_in : std_logic;
signal stop_in : std_logic;
signal start_in : std_logic;

signal time_up_out :  std_logic;
signal time_down_out :  std_logic;

constant ClockPeriod : time := 20 ns;

begin
button_control0 : button_control
port map(
	time_up_in =>     time_up_in , 
	time_down_in =>   time_down_in, 
	stop_in =>        stop_in, 
	start_in =>       start_in , 
	                  
	time_up_out =>    time_up_out , 
	time_down_out =>  time_down_out, 

	rst => rst, 
    clk => clk
);
    PROCESS
    begin
    clk <= '0';
    wait for ClockPeriod / 2;
    clk <= '1';
    wait for ClockPeriod / 2;
    end process;
	
	rst <= '0', '1'after 20ns;
	
	--未开始时，时间加减的验证（未开始状态下可加减时间）
	--time_up_in <= '0', '1' after 30ns, '0'after 50ns, '1' after 70ns, '0' after 90ns;
	--time_down_in <= '0', '0' after 30ns, '1'after 50ns, '0' after 70ns, '1' after 90ns;
	--PROCESS	--（突发奇想的一种写法）
    --begin
    --time_up_in <= '0';
    --wait for ClockPeriod+1ns;
    --time_up_in <= '1';
    --wait for ClockPeriod+1ns;
    --end process;


	--初始化中，验证按键失效时间（查看多少ns后可以改变状态，验证初始化所占时间）
	--start_in <= '0', '1'after 30ns, '0' after 40ns;
	--stop_in <= '0', '1' after 50ns;
	
	--中断中，验证返回初始状态（初始状态下可以增减时间）
	--start_in <= '0', '1'after 30ns, '0' after 40ns;
	--stop_in <= '0', '1' after 50ns;
	--time_up_in <= '0', '1' after 710ns;
	
	--中断中，验证返回工作状态（工作状态下无法增减时间）
	--start_in <= '0', '1' after 30ns, '0' after 40ns, '1' after 760ns;
	--stop_in <= '0', '1' after 50ns, '0' after 70ns, '1'after 730ns;
	--time_up_in <= '0', '1' after 780ns;
	
end Behavioral;
