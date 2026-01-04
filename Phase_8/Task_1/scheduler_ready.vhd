LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY scheduler_ready IS
PORT(
 clk        : in  std_logic;
 rst        : in  std_logic;
 wr_en      : in  std_logic;
 addr       : in  std_logic_vector(1 downto 0);
 wr_data    : in  std_logic_vector(31 downto 0);
 rd_data    : out std_logic_vector(31 downto 0)
);
END ENTITY;

ARCHITECTURE Behaviour OF scheduler_ready IS 

SIGNAL reg0, reg1, reg2, reg3 : std_logic_vector(31 downto 0);

BEGIN

register_writer : PROCESS(clk)
BEGIN
IF RISING_EDGE(clk) THEN
IF RST = '1' THEN

 rd_data <= (others => '0');
 reg0    <= (others => '0');
 reg1    <= (others => '0');
 reg2    <= (others => '0');
 reg3    <= (others => '0');

ELSIF wr_en = '1' THEN
 CASE addr IS
 WHEN "00" => reg0 <= wr_data;
 WHEN "01" => reg0 <= wr_data;
 WHEN "10" => reg0 <= wr_data;
 WHEN "11" => reg0 <= wr_data;
 WHEN others => null;
 END CASE:
 
END IF;
END IF;
END PROCESS:

WITH addr SELECT
 rd_data <= reg0 WHEN "00",
            reg1 WHEN "01",
            reg2 WHEN "10",
            reg3 WHEN "11",
            (others => '0')) WHEN others;

END;
