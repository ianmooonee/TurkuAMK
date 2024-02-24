LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY clock_devider IS
    GENERIC (
        OUT_FREQ : INTEGER := 1e3
    );

    PORT (
        clock_input : IN STD_LOGIC;
        n_reset : IN STD_LOGIC := '0';
        clock_out : OUT STD_LOGIC
    );
END clock_devider;

ARCHITECTURE rtl OF clock_devider IS

    CONSTANT MAX_COUNT : INTEGER := 125e6/OUT_FREQ; --number of cycles
    CONSTANT HALF_CLOCK_CLICLE : INTEGER := MAX_COUNT / 2; --half of max count to be able to produce a 50% pulse ratio
    SIGNAL divider : INTEGER RANGE 0 TO MAX_COUNT := 0; --counter

BEGIN

    clock_devider_process : PROCESS (clock_input, n_reset)
    BEGIN
        IF n_reset = '0' THEN
            divider <= 0;
            clock_out <= '0';
        ELSIF rising_edge(clock_input) THEN
            IF (divider >= MAX_COUNT - 1) THEN
                divider <= 0;
            ELSE
                divider <= divider + 1;
            END IF;
            IF divider > HALF_CLOCK_CLICLE THEN
                clock_out <= '1';
            ELSE
                clock_out <= '0';
            END IF;
        END IF;
    END PROCESS clock_devider_process;

END ARCHITECTURE rtl;