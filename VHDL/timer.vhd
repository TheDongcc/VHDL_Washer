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
constant time_default : std_logic_vector(6 downto 0) := "0011110";		--Ĭ��ʱ�䣬����Ϊ30����
begin
	process(clk, rst, time_down_second)
	variable time_set : std_logic_vector(6 downto 0) := time_default;	--��ʾʱ��
	variable count_down : std_logic_vector(6 downto 0) := "0000011";	--��ʼ��ʹ�õĵ���ʱʱ��
	variable temp : integer := 0;
	begin
		if(falling_edge(rst)) then
			seg_transmit <= "0011110";
			time_set := time_default;	
			count_down := "0000011";
			temp := 0;
			reset <= '1';
		elsif(rising_edge(clk)) then

			if(pattern = "00" or pattern = "11") then --δ��ʼ����ͣ�У�����״̬����ͨ�������ı�ʱ��
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
	
			elsif(pattern = "01") then   --��ʼ��������ͨ�������ı�ʱ�䣬���ǻ��Զ�ͨ����ʱ�ı�ʱ��
			    reset <= '1';
			    temp := temp + 1;
			    seg_transmit <= count_down;
			    if(temp = 10) then
			         temp := 0;
			         count_down := count_down - '1';	         
			    end if;
			    
			elsif(pattern = "10") then     --�����У�����ʱÿ���ɵ������ģ�鷢����һ���ӽ����źŵ������Ὣ����ܼ���-1
				
			    seg_transmit <= time_set;
			    if(time_down_second = '1' and reset = '1') then
					time_set := time_set - '1';
			    end if;
			    
			    if(time_set <= "0000000") then	--����ʱʱ�䵽��ʱ��������λ�źţ��������·���и�λ
				    reset <= '0';				--reset���ӵ�ϵͳ��λrst��
				end if;
				
			end if;	 
		end if;

	end process;

end Behavioral;
