----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2023 18:17:46
-- Design Name: 
-- Module Name: rgb - Behavioral
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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY rgb IS
    PORT (
        clock_input : IN STD_LOGIC;
        n_reset : IN STD_LOGIC := '0';
        pulses : IN STD_LOGIC := '0';
        btn : IN STD_LOGIC := '0';
        led5_r : OUT STD_LOGIC;
        led5_g : OUT STD_LOGIC;
        led5_b : OUT STD_LOGIC
    );
END rgb;

ARCHITECTURE rtl OF rgb IS

    TYPE color_state_t IS (R, G, B);
    SIGNAL color_state : color_state_t;
    SIGNAL RGB_Led_5 : STD_LOGIC_VECTOR(0 TO 2);

BEGIN
    led5_r <= RGB_Led_5(2);
    led5_g <= RGB_Led_5(1);
    led5_b <= RGB_Led_5(0);

    color_pulser : PROCESS (clock_input, n_reset)
    BEGIN
        IF n_reset = '0' THEN

            color_state <= R;

        ELSIF rising_edge(clock_input) THEN
            IF pulses = '1' THEN
                CASE color_state IS
                    WHEN R =>
                        color_state <= G;
                    WHEN G =>
                        color_state <= B;
                    WHEN B =>
                        color_state <= R;
                    WHEN OTHERS =>
                        color_state <= R;
                END CASE;

            END IF;
        END IF;

    END PROCESS color_pulser;

    WITH color_state SELECT
        RGB_Led_5 <= "001" WHEN R,
        "010" WHEN G,
        "100" WHEN B;
END rtl;