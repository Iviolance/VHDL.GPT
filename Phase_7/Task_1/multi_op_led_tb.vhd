LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY multi_op_led_tb IS
END ENTITY;

ARCHITECTURE testbench OF tb IS 

 CONSTANT clk_period : natural := 20 ns;
 
 SIGNAL clk_tb : STD_LOGIC;
 SIGNAL rst_tb : STD_LOGIC;
 SIGNAL button_press_tb : STD_LOGIC;
 SIGNAL led_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
 SIGNAL exp_led : STD_LOGIC_VECTOR(7 DOWNTO 0):= "10000000";

 COMPONENT dut IS
 PORT(
    
 );

 PROCEDURE press(SIGNAL btn : OUT STD_LOGIC) IS
 BEGIN
  btn <= '1';
  WAIT FOR clk_period;
  btn <= '0';
  WAIT FOR clk_period;
 END PROCEDURE;

BEGIN



-------------------------------------------------
-- instantiation
-------------------------------------------------
dut_insta : ENTITY
 PORT MAP(

 );

-------------------------------------------------
-- clock function
-------------------------------------------------
clk <= NOT clk AFTER clk_period;

-------------------------------------------------
-- rst process  
-------------------------------------------------
 
-------------------------------------------------
-- button process  
-------------------------------------------------
 btn_generation : PROCESS
 BEGIN
  button_press_tb <= '0'; 
  WAIT FOR 200 ns;
  button_press_tb <= '1';
  WAIT FOR clk_period;
  button_press_tb <= '0';
  WAIT FOR 200 ns;
  button_press_tb <= '1';
  WAIT FOR clk_period;
  button_press_tb <= '0';
 END PROCESS;


-------------------------------------------------
-- START OF TESTCASE
-------------------------------------------------
stim : PROCESS
BEGIN

-------------------------------------------------
-- RST TESTCASE 0: 
-------------------------------------------------
  rst <= '1'; 
  WAIT FOR 50 ns;
  rst <= '0';
  WAIT;

  ASSERT led_in = "10000000"
   REPORT "Reset FAIL: LEDs not 10000000, got=" & to_hstring(led_in)
   SEVERITY ERROR;
-------------------------------------------------
-- WRAP MODE TESTCASE 1:
-- no diret access to tick, thus we shall wait long enough for it
-------------------------------------------------
exp_led <= "10000000"

WAIT FOR 5*clk_period;
exp_led <= exp_led(0) & exp_led(7 DOWNTO 1);

ASSERT led_in = exp_led;
 REPORT "WRAP MODE FAIL : LEDs not same as exp_led=" & to_hstring(exp_led)
 SEVERITY ERROR;

WAIT FOR 5*clk_period;
exp_led <= exp_led(0) & exp_led(7 DOWNTO 1);

ASSERT led_in = exp_led;
 REPORT "WRAP MODE FAIL : LEDs not same as exp_led=" & to_hstring(exp_led)
 SEVERITY ERROR;

-------------------------------------------------
-- BIN MODE TESTCASE 2:
-------------------------------------------------
press(btn_press)

WAIT FOR clk_period;
exp_led <= "10000000";

ASSERT led_in = exp_led;
 REPORT "MODE SWITCH FAIL : expected reset pattern after press"
 SEVERITY ERROR;

-------------------------------------------------
-- BIN MODE TESTCASE 2:
-------------------------------------------------
press(btn_press)

WAIT FOR clk_period;
exp_led <= "10000000";

ASSERT led_in = exp_led;
 REPORT "MODE SWITCH FAIL : expected reset pattern after press"
 SEVERITY ERROR;



END;


END;
