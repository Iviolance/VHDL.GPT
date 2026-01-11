library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scheduler_ready is
  port(
    clk     : in  std_logic;
    rst     : in  std_logic;
    wr_en   : in  std_logic;
    addr    : in  std_logic_vector(1 downto 0);
    wr_data : in  std_logic_vector(31 downto 0);
    rd_data : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behaviour of scheduler_ready is
  signal reg0, reg1, reg2, reg3 : std_logic_vector(31 downto 0);
  signal enable, snapshot : std_logic;
  signal status_counter : unsigned(15 downto 0);
 
begin

  increment_count_proc : process 
  begin
  if rising_edge(clk) then
  if rst = '1' then
   status_counter <= (others => '0')
  elsif enable = '1' then
   status_counter <= status_counter + "1";
  else
   status_counter <= (others => '0')
  end if;
  end if;
  end process;

  enable   <= reg0(0);
  snapshot <= reg0(1);

  status_counter
  reg1

  register_writer : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        reg0 <= (others => '0');
        reg1 <= (others => '0');
        reg2 <= (others => '0');
        reg3 <= (others => '0');

      elsif wr_en = '1' then
        case addr is
          when "00" => reg0 <= wr_data;
          when "01" => reg1 <= wr_data;
          when "10" => reg2 <= wr_data;
          when "11" => reg3 <= wr_data;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  with addr select
    rd_data <= reg0 when "00",
               reg1 when "01",
               reg2 when "10",
               reg3 when "11",
               (others => '0') when others;


end architecture;
