LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY button_pulser IS
    GENERIC (
        DELAY : INTEGER := 2000;
        INTERVAL : INTEGER := 500
    );
    PORT (
        btn : IN STD_LOGIC := '0';
        btn_out : OUT STD_LOGIC :='0';
        clock_input : IN STD_LOGIC;
        n_reset : IN STD_LOGIC := '0'
    );
END button_pulser;

ARCHITECTURE rtl OF button_pulser IS
    TYPE pulser_states IS (IDLE, WAITT, REPEAT);
    SIGNAL pulser_state : pulser_states;
    SIGNAL count_delay : INTEGER := 0;
    SIGNAL count_interval : INTEGER := 0;
    SIGNAL long_press_ena : STD_LOGIC := '0';
    SIGNAL rc_ena : STD_LOGIC := '0';
    SIGNAL pulse : STD_LOGIC := '0';

BEGIN
    btn_pulser_process : PROCESS (clock_input, n_reset)
    BEGIN
        pulser_state <= IDLE;
        IF n_reset = '0' THEN
            btn_out <= '0';
            long_press_ena <= '0';
            rc_ena <= '0';
            pulser_state <= IDLE;
        ELSIF rising_edge(clock_input) THEN
            CASE pulser_state IS
                WHEN IDLE =>
                    long_press_ena <= '0';
                    rc_ena <= '0';
                    IF btn = '1' THEN
                        btn_out <= '1';
                        pulser_state <= WAITT;
                    ELSE
                        btn_out <= '0';
                    END IF;
                WHEN WAITT =>
                    long_press_ena <= '1';
                    rc_ena <= '0';
                    IF btn = '0' THEN
                        long_press_ena <= '0';
                        pulser_state <= IDLE;
                    END IF;
                WHEN REPEAT =>
                        long_press_ena <= '0';
                        rc_ena <= '1';
                        IF btn = '0' then
                            rc_ena <= '0';
                            pulser_state <= IDLE;
                        END IF;
                WHEN OTHERS =>
                    pulser_state <= IDLE;
            END CASE;
        END IF;
    END PROCESS btn_pulser_process;
    
    lp_counter_process: PROCESS (clock_input, n_reset)
    BEGIN
        IF n_reset = '0' THEN
            count_delay <= 0;
        END IF;
        IF btn = '0' THEN
            IF long_press_ena = '1' THEN
                IF rising_edge(clock_input) THEN
                    count_delay <= count_delay + 1;
                    IF count_delay >= DELAY THEN
                        pulser_state <= REPEAT;
                        count_delay <= 0;
                    END IF;
                END IF;
            END IF;
         END IF;
    END PROCESS lp_counter_process;
        
    rc_counter_process: PROCESS (clock_input, n_reset)
    BEGIN
        IF n_reset = '0' THEN
            count_interval <= 0;
        END IF; 
        IF rc_ena = '1' THEN
            IF rising_edge(clock_input) THEN
                pulse <= '0';
                count_interval <= count_interval + 1;
                IF count_interval >= INTERVAL THEN
                    pulse <= '1';
                    count_interval <= 0;
                END IF;
            END IF;
        END IF;
    END PROCESS rc_counter_process;
END ARCHITECTURE rtl;