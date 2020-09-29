--
-- Rafael C.
-- ref:
--   - https://www.intel.com/content/www/us/en/programmable/quartushelp/13.0/mergedProjects/hdl/vhdl/vhdl_pro_state_machines.htm
--   - https://www.allaboutcircuits.com/technical-articles/implementing-a-finite-state-machine-in-vhdl/
--   - https://www.digikey.com/eewiki/pages/viewpage.action?pageId=4096117


library IEEE;
use IEEE.std_logic_1164.all;

entity stepmotor is
--  generic (
--    CLK_FREQ : natural := 50000000
--  );
    port (
        -- Gloabals
        clk   : in  std_logic;

        -- controls
        en      : in std_logic;                     -- 1 on/ 0 of
        dir     : in std_logic;                     -- 1 clock wise
        vel     : in std_logic_vector(1 downto 0);  -- 00: low / 11: fast

        -- I/Os
        phases  : out std_logic_vector(3 downto 0)
  );
end entity stepmotor;

architecture rtl of stepmotor is

   TYPE STATE_TYPE IS (s0, s1, s2, s3);
   SIGNAL state  : STATE_TYPE := s0;
   signal enable : std_logic  := '0';
   signal pha    : std_logic_vector(3 downto 0) := "0001";
   signal topCounter : integer range 0 to 50000000;
  
begin

  process(clk)
  begin
    if (rising_edge(clk)) then
      CASE state IS
      WHEN s0=>
        IF enable = '1' THEN
          state <= s1;
        ELSE
          state <= s0;
        END IF;
      WHEN s1=>
        IF enable = '1' THEN
          state <= s2;
        ELSE
          state <= s1;
        END IF;
      WHEN s2=>
        IF enable = '1' THEN
          state <= s3;
        ELSE
          state <= s2;
        END IF;
      WHEN s3=>
        IF enable = '1' THEN
          state <= s0;
        ELSE
          state <= s3;
        END IF;
      when others=>
        state <= s0;
      END CASE;
    end if;
  end process;

  PROCESS (state)
   BEGIN
      CASE state IS
        WHEN s0 =>
          if(dir = '1') then
            phases <= "0001";
          else
            phases <= "1000";
          end if;
        WHEN s1 =>
          if(dir = '1') then
            phases <= "0010";
          else
            phases <= "0100";
          end if;
        WHEN s2 =>
          if(dir = '1') then
            phases <= "0100";
          else
            phases <= "0010";
          end if;
        when s3 =>
          if(dir = '1') then
            phases <= "1000";
          else
            phases <= "0001";
          end if;
        when others =>
          phases <= "0000";
      END CASE;
   END PROCESS;

   topCounter <= 10000000 when vel = "00" else
                  5000000 when vel = "01" else
                   500000 when vel = "10" else
                   100000;

  process(clk)
    variable counter : integer range 0 to 50000000 := 0;
  begin
    if (rising_edge(clk)) then
      if (en = '1') then
        if (counter < topCounter) then
          counter := counter + 1;
          enable  <= '0';
        else
          counter := 0;
          enable  <= '1';
        end if;
      end if;
    end if;
  end process;

end rtl;