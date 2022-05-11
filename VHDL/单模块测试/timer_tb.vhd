library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity timer_tb is
--  Port ( );
end timer_tb;

architecture Behavioral of timer_tb is
component timer is
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
end component;

signal clk : std_logic;
signal rst : std_logic;
signal reset : std_logic;
signal time_down_second : std_logic;
signal time_up : std_logic;
signal time_down : std_logic;
signal pattern : std_logic_vector(1 downto 0);
signal seg_transmit : std_logic_vector(6 downto 0);
constant ClockPeriod : time := 20 ns;

begin
timer0 : timer
port map(
	clk         		=> clk,        
	rst         		=> rst,        
	time_down_second	=> time_down_second, 
	reset 				=> reset, 
	time_up   		  	=> time_up,    
	time_down   		=> time_down,  
	pattern     		=> pattern,         
	seg_transmit 		=> seg_transmit
);

	PROCESS
    begin
    clk <= '0';
    wait for ClockPeriod / 2;
    clk <= '1';
    wait for ClockPeriod / 2;
    end process;
	
	rst <= '1', '0'after 20ns,'1'after 30ns;

	--time_up <= '0', '1' after 40ns, '0' after 60ns, '1' after 80ns; --验证非使能状态下是否可以加减时间
	time_down_second <= '0', '1' after 40ns, '0' after 60ns, '1' after 80ns; --验证非使能状态下是否可以加减时间
--	pattern <= "01";
--    pattern <= "11";	--中断状态下
    pattern <= "10";
	--time_down <= '0', '1'after 100ns;
--	reset <= '1'; --不需要人为设置，否正会强不定

end Behavioral;
