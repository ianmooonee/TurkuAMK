----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2023 11:57:22
-- Design Name: 
-- Module Name: clock_divider_tb - Behavioral
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

ENTITY clock_divider_tb IS
    --  Port ( );
END clock_divider_tb;

ARCHITECTURE Behavioral OF clock_divider_tb IS
    CONSTANT SYSCLK_PERIOD : TIME := 8 ns; -- 125MHz
    SIGNAL n_reset_test : STD_LOGIC := '0'; -- init to 0 for simulation
    SIGNAL clk_in_test : STD_LOGIC := '0'; -- init to 0 for simulation
    SIGNAL clk_out_test : STD_LOGIC := '0';
    SIGNAL btn_test : STD_LOGIC := '0';
    SIGNAL long_press_test: STD_LOGIC := '0';

    COMPONENT clock_devider IS
        GENERIC (
            OUT_FREQ : INTEGER := 25e6
        );

        PORT (
            clock_input : IN STD_LOGIC;
            n_reset : IN STD_LOGIC := '0';
            clock_out : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT button_pulser IS
        GENERIC (
            DELAY : INTEGER := 3;
            INTERVAL : INTEGER := 2
        );
        PORT (
            clock_input : IN STD_LOGIC;
            btn : IN STD_LOGIC;
            btn_out : OUT STD_LOGIC;
            n_reset : IN STD_LOGIC
        );
    END COMPONENT button_pulser;

BEGIN
    clk_in_test <= NOT clk_in_test AFTER (SYSCLK_PERIOD/2);

    stimulus_p : PROCESS
    BEGIN
        -- after 10 clock cycles deassert reset
        WAIT FOR (SYSCLK_PERIOD * 10);
        n_reset_test <= '1';
        WAIT FOR (SYSCLK_PERIOD * 10);
        n_reset_test <= '0';
        WAIT FOR (SYSCLK_PERIOD * 10);
        n_reset_test <= '1';
        WAIT; -- wait here forever    
    END PROCESS;

    stimulus_button : PROCESS
    BEGIN
            wait for 500 us;
                btn_test <= '1';
            wait for 1000 us;
                btn_test <= '0';
            wait for 1000 us;
                btn_test <= '1';
            wait for 20000 us;
                btn_test <= '0';
            wait for 1000 us;
                btn_test <= '1';
            wait;
    END PROCESS;
    
    dut_clk_devider : clock_devider
    GENERIC MAP(
        OUT_FREQ => 1e3
    )
    PORT MAP(
        n_reset => n_reset_test,
        clock_out => clk_out_test,
        clock_input => clk_in_test
    );

    dut_button_pulser : button_pulser
    GENERIC MAP(
        DELAY => 10,
        INTERVAL => 10
    )
    PORT MAP(
        clock_input => clk_out_test,
        n_reset => n_reset_test,
        btn => btn_test,
        btn_out => long_press_test
    );

END Behavioral;