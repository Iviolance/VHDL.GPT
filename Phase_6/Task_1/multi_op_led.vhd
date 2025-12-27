-- 1. Wrap chaser – LED shifts in one direction and wraps around.
-- 2. Ping-pong – LED bounces left ↔ right using a direction bit.
-- 3. Binary counter – LEDs count upward as an 8-bit value.

LIBRARY ieee;
USE ieee.std_logic_1164;
USE ieee.numeric_std;

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

TYPE state_t IS (state_idle, state_1, state_2, state_3);
SIGNAL state : state_t := state_idle;
SIGNAL leds_reg : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL tick : STD_LOGIC;
SIGNAL btn_press_s : STD_LOGIC;
SIGNAL cnt : integer := 0;


BEGIN

leds <= leds_reg;

state_machine_led_multi_func : PROCESS(clk)
BEGIN
IF tick = '1' THEN
CASE state IS
IF rising_edge(clk) THEN
IF rst = '1' THEN 
 leds_reg <= "10000000"
 state <= state_idle;
 cnt <= 0;
 state <= state_idle;
 tick <= '0';
ELSE
WHEN state_idle => 
     leds_reg <= "10000000";
     IF btn_press_s = '1' THEN
      state <= state_1;
     ELSE
      state <= state;
     END IF;

WHEN state_1 =>
     
     IF btn_press_s = '1' THEN
      state <= state_2;
      leds_reg = "10000000"
     ELSE
      state <= state_1;
      IF tick = '1' THEN
       leds_reg <= leds_reg(0) & leds_reg(7 DOWNTO 1);
      ELSE 
       leds_reg <= leds_reg;
      END IF;
     END IF: 

WHEN state_2 =>
     
     IF btn_press_s = '1' THEN
      state <= state_3;
      leds_reg = "10000000";
     ELSE
      IF tick = '1' THEN
      IF leds_reg = "10000000" THEN
       leds_reg <= leds_reg(0) & leds_reg(7 DOWNTO 1);
      ELSIF leds_reg = "00000001" THEN
       leds_reg <= leds_reg (6 DOWNTO 0) & leds_reg(7)
      END IF;
      ELSE
       leds_reg <= led_reg;
      END IF;
     END IF;

WHEN state_3 =>

     IF btn_press_s = '1' THEN
      state <= state_1;
      leds_reg = "10000000";
     ELSE
      IF tick = '1' THEN
       led_reg <= STD_LOGIC_VECTOR(unsigned(led_reg) + 1);
      ELSE
       led_reg <= led_reg;
      END IF;
     END IF;
      
    
WHEN OTHERS => 
     leds_reg <= "10000000";
     state <= state_idle;

END IF;
END IF;
END CASE;
END IF;
END PROCESS;

counter : PROCESS
BEGIN
IF rising_edge(clk)
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
END PROCESS:

END;

