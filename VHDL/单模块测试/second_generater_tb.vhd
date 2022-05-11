library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity second_generater_tb is
--  Port ( );
end second_generater_tb;

architecture Behavioral of second_generater_tb is
component second_generater is
port(
	clk     : in std_logic;
	rst     : in std_logic;
	second  : out std_logic
);
end component;
signal clk : std_logic := '0';
signal rst: std_logic := '0';
signal second : std_logic := '0';
constant ClockPeriod : time := 10ns;
begin
second_generater0 : second_generater
port map(
    clk => clk,
    rst => rst, 
    second => second
);
    rst <= '0', '1'after 10ns;
    PROCESS
    begin
    clk <= '0';
    wait for ClockPeriod / 2;
    clk <= '1';
    wait for ClockPeriod / 2;
    end process;
    
end Behavioral;
