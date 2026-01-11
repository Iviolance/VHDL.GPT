

-----------------------------
CASE
-----------------------------
 addr       : in  std_logic_vector(1 downto 0);
 
 CASE addr IS
 WHEN "00" => reg0 <= wr_data;
 WHEN "01" => reg1 <= wr_data;
 WHEN "10" => reg2 <= wr_data;
 WHEN "11" => reg3 <= wr_data;
 WHEN others => null;
 END CASE;

-----------------------------
WHEN
-----------------------------
 rd_data <= reg0 WHEN "00",
            reg1 WHEN "01",
            reg2 WHEN "10",
            reg3 WHEN "11",
            (others => '0') WHEN others;

 END;