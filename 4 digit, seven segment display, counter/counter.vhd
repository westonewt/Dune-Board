library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Lab4 is
  Port (clk:         in std_logic;
        reset:       in std_logic;
        Change:      in std_logic;
        EMV:         in std_logic;
        btn: in std_logic;
        RL:         out std_logic;
        GL:         out std_logic;
        YL:         out std_logic;
        led:        out std_logic_vector(1 downto 0);
        out_7seg:   out std_logic_vector(6 downto 0));
end Lab4;

architecture Behavioral of Lab4 is

  constant count_for_1Hz: natural:=64000000;
  signal count : natural;
  signal clk_1Hz: std_logic:='0';
  signal clk_out: std_logic:='0';
  signal state: std_logic_vector(2 downto 0):="000";
  signal D:     std_logic_vector(2 downto 0);
  signal HR: std_logic;
  signal HY: std_logic;
  signal HG: std_logic;
  signal SR: std_logic;
  signal SY: std_logic;
  signal SG: std_logic;

begin 

  clock_1Hz: process(clk)
  begin
    if rising_edge(clk) then
      if(count<count_for_1Hz) then
        count<=count+1;
      else
        count<=0;
        clk_out<=not clk_out;
        clk_1Hz<=clk_out;
      end if;
    end if;
  end process;

  TrafficIntersection: process (clk, clk_1Hz)
  begin

    -- flip flop inputs
    D(0) <= ((not EMV) and ((not state(0) and state(1) and state(2) and change) or (state(0) and not state(2)) or (state(0) and not state(2)) or (state(0) and not change)));
    D(1) <= ((not EMV) and ((state(1) and not state(2)) or (state(1) and not change) or (not state(1) and state(2) and change)));
    D(2) <= ((not EMV) and ((not state(2) and change) or (state(2) and not change)));

    if (change = '1') then
      led(0) <= '1';
    end if;

    if (EMV = '1') then
      led(1) <= '1';
    end if;

    if (btn = '1') then
      RL <= SR;
      GL <= SG;
      YL <= SY;
    else 
      RL <= SR;
      GL <= SG;
      YL <= SY;
    end if;
  end process;

  D_flipflop : process (clk_1Hz) is
  begin
  
    -- D flip flops
  if (rising_edge(clk_1Hz)) then

    if (reset = '1') then
      state <= "000";
    else
      state(0) <= D(0);
      state(1) <= D(1);
      state(2) <= D(2);
    end if;
  end if;

    -- based on the states of the flip flops the output changes
    if (state="000")    then out_7seg <= "0111111"; SG <= '0'; SY <= '0'; SR <= '1'; HG <= '1'; HY <= '0'; HR <= '0';
    elsif (state="001") then out_7seg <= "0111111"; SG <= '0'; SY <= '0'; SR <= '1'; HG <= '0'; HY <= '1'; HR <= '0';
    elsif (state="010") then out_7seg <= "1101101"; SG <= '1'; SY <= '0'; SR <= '0'; HG <= '0'; HY <= '0'; HR <= '1';
    elsif (state="011") then out_7seg <= "1100110"; SG <= '1'; SY <= '0'; SR <= '0'; HG <= '0'; HY <= '0'; HR <= '1';
    elsif (state="100") then out_7seg <= "1001111"; SG <= '1'; SY <= '0'; SR <= '0'; HG <= '0'; HY <= '0'; HR <= '1';
    elsif (state="101") then out_7seg <= "1011011"; SG <= '1'; SY <= '0'; SR <= '0'; HG <= '0'; HY <= '0'; HR <= '1';
    elsif (state="110") then out_7seg <= "0000110"; SG <= '1'; SY <= '0'; SR <= '0'; HG <= '0'; HY <= '0'; HR <= '1';
    elsif (state="111") then out_7seg <= "0111111"; SG <= '0'; SY <= '1'; SR <= '0'; HG <= '0'; HY <= '0'; HR <= '1';
    else
    end if;
  end process D_flipflop;
end Behavioral;