-- 1. Wrap chaser – LED shifts in one direction and wraps around.
-- 2. Ping-pong – LED bounces left ↔ right using a direction bit.
-- 3. Binary counter – LEDs count upward as an 8-bit value.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY multi_op_led IS
GENERIC(
    timer : NATURAL := 2_000_000
);
PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    btn_press : IN STD_LOGIC;
    leds: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END ENTITY; 

ARCHITECTURE behavioural OF multi_op_led IS

TYPE state_t IS (state_idle, WRAP_MODE, BIN_MODE, state_3);
SIGNAL state : state_t := state_idle;
SIGNAL leds_reg : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL tick : STD_LOGIC;
SIGNAL cnt : integer := 0;


BEGIN

leds <= leds_reg;

state_machine_led_multi_func : PROCESS(clk)
BEGIN
IF rising_edge(clk) THEN
IF rst = '1' THEN 
 leds_reg <= "10000000";
 state <= state_idle;

ELSIF btn_press = '1' THEN

-- Mode switching (not tick-gated)

CASE state IS
 WHEN state_idle => 
      leds_reg <= "10000000";
       state <= WRAP_MODE;
 
 WHEN WRAP_MODE => 
      leds_reg <= "10000000";
       state <= BIN_MODE;
 
 WHEN BIN_MODE => 
      leds_reg <= "10000000";
       state <= WRAP_MODE;
END CASE;
 ELSIF tick = '1' THEN
  CASE state IS 
   WHEN state_idle => 
        leds_reg <= "10000000";
   
   WHEN WRAP_MODE =>
        leds_reg <= leds_reg(0) & leds_reg(7 DOWNTO 1);
   
   WHEN BIN_MODE =>
          leds_reg <= std_logic_vector(unsigned(leds_reg) + 1);
       
   WHEN OTHERS => 
        leds_reg <= "10000000";
        state <= state_idle;
  END CASE;
 END IF;
END IF;
END IF;
END PROCESS;

counter : PROCESS(clk)
BEGIN
IF rising_edge(clk) THEN
IF rst = '1' THEN
 tick <= '0';
 cnt <= 0;
ELSE
 IF cnt < timer THEN
  cnt <= cnt + 1;
  tick <= '0';
 ELSE 
  cnt <= 0;
  tick <= '1';
 END IF;
END IF;
END IF;
END PROCESS;

END;

