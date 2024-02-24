----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/09/2019 10:47:12 AM
-- Design Name: 
-- Module Name: led_thingy_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led_thingy_top is
  Port (
    btn :       in  STD_LOGIC_VECTOR(1 downto 0);
    sw :        in  STD_LOGIC_VECTOR(1 downto 0);
    led :       out  STD_LOGIC_VECTOR (3 downto 0);
    led4_r :    out STD_LOGIC;
    led4_g :    out STD_LOGIC;
    led4_b :    out STD_LOGIC;
    led5_r :    out STD_LOGIC;
    led5_g :    out STD_LOGIC;
    led5_b :    out STD_LOGIC
  );
end led_thingy_top;

architecture Behavioral of led_thingy_top is
   
    -- group of RGB led signals
    signal RGB_Led_4: std_logic_vector(0 to 2);
    -- group of RGB led signals
    signal RGB_Led_5: std_logic_vector(0 to 2);
    signal aux: std_logic_vector(0 to 2);
    
    signal leds1 : std_logic_vector (3 downto 0);
    signal leds2 : std_logic_vector (3 downto 0);

begin
    -- Some "housekeeping" first
    -- map signal "RGB_Led_4" to actual output ports
    led4_r <= RGB_Led_4(2);
    led4_g <= RGB_Led_4(1);
    led4_b <= RGB_Led_4(0);
    
    -- map signal "RGB_Led_5" to actual output ports
    led5_r <= RGB_Led_5(2);
    led5_g <= RGB_Led_5(1);
    led5_b <= RGB_Led_5(0);
    
    with btn(1 downto 0) select
        leds1 <=        "0001" when "00",
                        "0010" when "01",
                        "0100" when "10",
                        "1000" when "11",
                        "0000" when others;
                        
    --with btn(1 downto 0) select
        --leds2 <=        "1000" when "00",
                        --"1110" when "01",
                        --"1110" when "10",
                        --"0101" when "11",
                        --"0000" when others;
    
    leds2(0) <= btn(0) and btn(1);
    leds2(1) <= btn(0) xor btn(1);
    leds2(2) <= btn(0) or btn(1);
    leds2(3) <= btn(0) nand btn(1);
    
    --leds2(0) <= '1' when (btn(0)='1' and btn(1)='1') else
                --'0';
    --leds2(1) <= '1' when (btn(0)='0' and btn(1)='1') else
                --'1'  when (btn(0)='1' and btn(1)='0') else
                --'0';
    --leds2(2) <= '1' when (btn(0)='1' or btn(1)='1') else
                --'0';
    --leds2(3) <= '0' when (btn(0)='1' and btn(1)='1') else
                --'1';
                
--    leds2 <= "1000" when (btn(0)='0' and btn(1)='0') else
--             "0101" when (btn(0)='1' and btn(1)='1') else
--             "1110";
                        
    -- Control of RGB LED 4
    with btn(1 downto 0) select
        RGB_Led_4 <=    "001" when "01", --red
                        "010" when "10", --green
                        "100" when "11", --blue
                        "000" when others; --off
         
    with sw(1) select
       led <= leds1 when '0',
              leds2 when  others ;
             
    --led <= leds1 when sw(1)='0' else leds2;
    
    with sw(1 downto 0) select
       RGB_Led_5 <= "000" when "00",
                    RGB_Led_4 when "01",
                    "111" when others;
    
       
                                        
end Behavioral;
