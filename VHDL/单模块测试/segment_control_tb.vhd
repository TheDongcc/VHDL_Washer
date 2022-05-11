library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity segment_control_tb is
--  Port ( );
end segment_control_tb;

architecture Behavioral of segment_control_tb is
component segment_control is
Port ( 
	clk            : in std_logic;
	rst            : in std_logic;
	time_in        : in std_logic_vector(6 downto 0);
	seg_control    : out std_logic_vector(7 downto 0)
);
end component;
signal clk : std_logic;
signal rst : std_logic;
signal time_in : std_logic_vector(6 downto 0);
signal seg_control : std_logic_vector(7 downto 0);
constant ClockPeriod : time := 20 ns;
begin
segment_control0:segment_control
port map(
	clk => clk, 
	rst => rst, 
	time_in => time_in, 
	seg_control => seg_control
);
    rst <= '0', '1'after 10ns;
	PROCESS
    begin
    clk <= '0';
    wait for ClockPeriod / 2;
    clk <= '1';
    wait for ClockPeriod / 2;
    end process;
    
    time_in <= "0111100", "0111010"after 50ns, "0100001"after 90ns;
    
end Behavioral;
