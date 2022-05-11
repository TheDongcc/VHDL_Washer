library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity second_generater is
port(
	clk    : in std_logic;
	rst    : in std_logic;
	second : out std_logic
);
end second_generater;

architecture Behavioral of second_generater is
signal clk_out : std_logic := '0';
constant divide_multi : integer := 10; --定义分频倍数，这里定义为20倍
begin
	process(clk, rst) 
	variable temp : integer := 0;
	begin
	if(falling_edge(rst)) then
	   second <= '0';
	elsif(rising_edge(clk)) then
		temp := temp + 1;
	end if;
	if(temp = divide_multi) then
		temp := 0;
		clk_out <= not clk_out;
	end if;
	second <= clk_out;
	end process;
    
end Behavioral;
