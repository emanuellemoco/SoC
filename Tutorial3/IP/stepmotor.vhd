--
-- Rafael C.
-- ref:
--   - https://www.intel.com/content/www/us/en/programmable/quartushelp/13.0/mergedProjects/hdl/vhdl/vhdl_pro_state_machines.htm
--   - https://www.allaboutcircuits.com/technical-articles/implementing-a-finite-state-machine-in-vhdl/
--   - https://www.digikey.com/eewiki/pages/viewpage.action?pageId=4096117

library IEEE;
use IEEE.std_logic_1164.all;

entity stepmotor is
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
   signal timerDone : std_logic  := '0';
   signal topCounter : integer range 0 to 50000000;
	signal step: integer := 5000;
   signal stepCounter: integer range 0 to 10000 := 0;
   signal timeCounter: std_logic  := '0';

BEGIN

  process(clk)
  
  BEGIN
	
    if (rising_edge(clk))  then
		
		if (timerDone = '1') then 
			stepCounter <= stepCounter + 1;

	 case state IS
      WHEN s0=>
          state <= s1;
      WHEN s1=>     
          state <= s2;
      WHEN s2=>
          state <= s3;
      WHEN s3=>
          state <= s0;
      when others=>
        state <= s0;
      END CASE;
    end if;
	 end if;
  end process;
 
  PROCESS (state)
   BEGIN

		
		if (dir = '1') then
			CASE state IS
			  WHEN s0 =>
				 phases <= "0001";
			  WHEN s1 =>
				 phases <= "0010";
			  WHEN s2 =>
				 phases <= "0100";
			  when s3 =>
				 phases <= "1000";
			  when others =>
				 phases <= "0000";
			END CASE;
			else 
			CASE state IS
			  WHEN s0 =>
				 phases <= "0000";
			  WHEN s1 =>
				 phases <= "1000";
			  WHEN s2 =>
				 phases <= "0100";
			  when s3 =>
				 phases <= "0010";
			  when others =>
				 phases <= "0001";
			END CASE;

			end if;



   END PROCESS;

  topCounter <= 10000000 when vel = "00" 
                else
                  5000000 when vel = "01" 
                  else
                    100000 when vel = "10" 
                    else
                      100000;

  process(clk)
    variable counter : integer range 0 to 50000000 := 0;
  begin
    if (rising_edge(clk)) then

	 
      if (en = '1') then
			if (stepCounter < step) then
			  if (counter < topCounter) then
				 counter := counter + 1;
				 timerDone  <= '0';
        else
          counter := 0;
          timerDone  <= '1';
        end if;
        end if;
		  end if;
    end if;
  end process;

end rtl;