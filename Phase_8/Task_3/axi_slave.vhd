library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity axi_slave is 
    port (
        clk     : in std_logic;
        rst     : in std_logic;

    -- write address channel
        awvalid : in  std_logic;
        awaddr  : in  std_logic_vector(1 downto 0);

    -- write data channel
        wvalid  : in  std_logic;
        wdata   : in  std_logic_vector(31 downto 0);

    -- read address channel
        arvalid : in  std_logic;
        araddr  : in  std_logic_vector(1 downto 0);

    -- read data channel
        rvalid  : out std_logic;
        rdata   : out std_logic_vector(31 downto 0);
        
    -- write response
        bvalid  : out std_logic
    );    
end entity;

architecture behaviour of axi_slave is

signal reg0, reg1, reg2, reg3 : std_logic_vector(31 downto 0) => (others = '0');


begin 

------------------------------------
-- write behaviour
------------------------------------

process(clk)
begin
if rising_edge(clk) then
if rst = '1' then
    reg0 <= (others => '0');
    reg1 <= (others => '0');
    reg2 <= (others => '0');
    reg3 <= (others => '0');
    rdata <= (others => '0');
    rvalid <= '0';
    bvalid <= '0';
else
  rvalid <= '0';
  bvalid <= '0';
  
---------------------
-- write
---------------------
 if awvalid = '1' and wvalid = '1' then 
    bvalid <= '1';
    case awaddr is
        when "00" => reg0 <= wdata;
        when "01" => reg1 <= wdata;
        when "10" => reg2 <= wdata;
        when "11" => reg3 <= wdata;
        when others => null;
    end case;
 end if;
---------------------
-- read
---------------------
 if arvalid = '1' then 
  rvalid <= '1';
    case araddr is 
        when "00" => rdata <= reg0;
        when "01" => rdata <= reg1;
        when "10" => rdata <= reg2;
        when "11" => rdata <= reg3;
        when others => rdata <= (others => '0');
    end case; 
 end if;
 end if;
 end if;
end process;
  
end;
