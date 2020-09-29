library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.all;

entity peripheral_LED is
    generic (
        LEN  : natural := 4
    );
    port (
        -- Gloabals
        clk                : in  std_logic                     := '0';             
        reset              : in  std_logic                     := '0';             

        -- I/Os
		  stepmotor_pio : out std_logic_vector(3 downto 0);

        -- Avalion Memmory Mapped Slave
        avs_address     : in  std_logic_vector(3 downto 0)  := (others => '0'); 
        avs_read        : in  std_logic                     := '0';             
        avs_readdata    : out std_logic_vector(31 downto 0) := (others => '0'); 
        avs_write       : in  std_logic                     := '0';             
        avs_writedata   : in  std_logic_vector(31 downto 0) := (others => '0')
    );
end entity peripheral_LED;

architecture rtl of peripheral_LED is


component stepmotor is
    port (
        -- Gloabals
        clk   : in  std_logic;

        -- controls
        en      : in std_logic;                     -- 1 on/ 0 of
        dir     : in std_logic;                     -- 1 clock wise
        vel     : in std_logic_vector(1 downto 0);  -- 00: low / 11: fast
        phases  : out std_logic_vector(3 downto 0)
  );
end component;

signal en, dir : std_logic;
signal vel : std_logic_vector(1 downto 0);
signal reg_config : std_logic_vector(31 downto 0);

begin
  -- addres |
  --  0     | 31 ..............0
  --        |                  en
  --  1     |            ve1 vel0

   u1 : stepmotor port map( clk, en, dir, vel, stepmotor_pio(3 downto 0) );
		
	
  process(clk)
  begin
    if(rising_edge(clk)) then
        if(avs_address = "0000") then 		  
            if(avs_write = '1') then
					    reg_config <= avs_writedata;    
          elsif(avs_read = '1') then
					  avs_readdata <= reg_config;
        end if;
        elsif (avs_address = "0001") then
            if(avs_write = '1') then
              vel <= avs_writedata(1 downto 0);    
          elsif(avs_read = '1') then
            avs_readdata(1 downto 0) <= vel;
        end if;
        
        

        end if;
    end if;
  end process;
  
  en  <= reg_config(0);
  dir <= reg_config(1);


end rtl;
