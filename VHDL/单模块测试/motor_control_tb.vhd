library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity motor_control_tb is
--  Port ( );
end motor_control_tb;

architecture Behavioral of motor_control_tb is
component motor_control is
port ( 
	clk        : in std_logic;	--时钟为秒级
	rst        : in std_logic;
	
	pattern    : in std_logic_vector(1 downto 0);
	
	ticking    : out std_logic;

	motor      : out std_logic_vector(1 downto 0);
	leds       : out std_logic_vector(2 downto 0)
);
end component;
signal clk : std_logic;
signal rst : std_logic;
signal motor : std_logic_vector(1 downto 0);
signal leds : std_logic_vector(2 downto 0);
signal pattern : std_logic_vector(1 downto 0);
signal ticking : std_logic;
constant ClockPeriod : time := 20 ns;
begin
motor_control0 : motor_control
port map(
	clk  => clk, 
	rst => rst, 
	motor=> motor, 
	leds => leds,
	pattern => pattern,
	ticking => ticking
);
	PROCESS
    begin
    clk <= '0';
    wait for ClockPeriod / 2;
    clk <= '1';
    wait for ClockPeriod / 2;
    end process;
	
	rst <= '0', '1' after 20ns;
	--enable <= '0',  '1'after 50ns;--验证使能控制是否有效
	--pattern <= "01";
	pattern <= "10";
	
end Behavioral;

