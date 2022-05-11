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
	type states is (waiting, initial, working, interrupt);--δ��ʼ����ʼ���������У���ͣ��
	variable current_state : states := waiting;--             00    01     10     11
	variable initial_timer : integer := 0;
	variable temp : integer := 0;
	begin
		if(falling_edge(rst)) then	--��λ
		    current_state := waiting;
			temp := 0;
			pattern <= "00";
			buzzer <= '0';
			time_up_out <= '0';
			time_down_out <= '0';
		elsif(rising_edge(clk)) then 
			if(current_state = waiting) then --δ��ʼ״̬
			    pattern <= "00";			
				if(temp < 11) then			--�ϵ���������������
					if((temp rem 2) = 1) then
						buzzer <= '1';
					elsif((temp rem 2) = 0) then
						buzzer <= '0';
					end if;
					temp := temp + 1;
				end if;
				
				time_up_out <= '0';
				time_down_out <= '0';
				if(start_in = '1') then		--��ʼ��ť����
					buzzer <= '1';
					pattern <= "01";
					current_state := initial; --�����ʼ��״̬
				elsif(time_up_in = '1') then	--ʱ�����Ӱ���
					buzzer <= '1';
					time_up_out <= '1';
				elsif(time_down_in = '1') then	--ʱ����ٰ���
					buzzer <= '1';
					time_down_out <= '1';
				end if;
				
			elsif(current_state = initial) then	--��ʼ��״̬
				buzzer <= '0';
				time_up_out <= '0';
				time_down_out <= '0';
				initial_timer := initial_timer + 1;
				if((initial_timer rem 10) = 0) then	--��ʼ��ʱ��ÿ��һ���������һ��
					buzzer <= '1';
				end if;				
				if(initial_timer >= 30) then   --������֤�����޸ļ�ʱֵ�����ﶨ��30��ʱ������Ϊ3��

					initial_timer := 0;
					current_state := working;
					pattern <= "10";
					
				end if;
			elsif(current_state = working) then	--�Զ�ϴ��״̬
				buzzer <= '0';
				time_up_out <= '0';
				time_down_out <= '0';
				if(stop_in = '1') then	--�����ж�״̬
					buzzer <= '1';
					current_state := interrupt;
					pattern <= "11";
				end if;
			elsif(current_state = interrupt) then --�ж�״̬
				buzzer <= '0';
				time_up_out <= '0';
				time_down_out <= '0';
				if(start_in = '1') then
					buzzer <= '1';
					current_state := working;	--���빤��״̬����ϴ��
					pattern <= "10";
				elsif(stop_in = '1') then
					buzzer <= '1';
					current_state := waiting; --����ϴ�ӣ�����δ��ʼ״̬
					pattern <= "00";
				elsif(time_up_in = '1') then	--�ж�״̬�ɶ�ʱ����иı�
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
