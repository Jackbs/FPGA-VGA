----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/19/2016 05:05:28 PM
-- Design Name: 
-- Module Name: Light_Controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Light_Controller is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           senseNS : in STD_LOGIC;
           senseEW : in STD_LOGIC;
           outputNS : out STD_LOGIC_VECTOR(2 downto 0);
           outputEW : out STD_LOGIC_VECTOR(2 downto 0));
end Light_Controller;

architecture Behavioral of Light_Controller is

type state_type is (EW_HOLDON,EW_IDLEON,EW_SLOW,NS_HOLDON,NS_IDLEON,NS_SLOW);
	
signal state  : state_type;
signal timer : std_logic_vector(30 downto 0) := (others => '0');

signal outputNS_int : std_logic_vector(2 downto 0) := (others => '0');
signal outputEW_int : std_logic_vector(2 downto 0) := (others => '0');

begin
	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '1' then
			state <= EW_HOLDON;
			timer <= (others => '0');
		elsif (rising_edge(clk)) then
			case state is
				when EW_HOLDON=>
					if timer(30) = '1' then
					    timer <= (others => '0');
						state <= EW_IDLEON;
					else
						timer <= timer + '1';
					end if;
				when EW_IDLEON=>
					if senseNS = '1' then
						state <= EW_SLOW;
						timer <= (others => '0');
					end if;
				when EW_SLOW=>
					if timer(30) = '1' then
						timer <= (others => '0');
						state <= NS_HOLDON;
					else
						timer <= timer + '1';
					end if;
				when NS_HOLDON =>
					if timer(30) = '1' then
						timer <= (others => '0');
						state <= NS_IDLEON;
					else
						timer <= timer + '1';
					end if;
				when NS_IDLEON=>
                    if senseEW = '1' then
                        state <= NS_SLOW;
                        timer <= (others => '0');
                    end if;
                when NS_SLOW=>
                     if timer(30) = '1' then
                        state <= EW_HOLDON;
                        timer <= (others => '0');
                     else
                        timer <= timer + '1';
                     end if;
			end case;
		end if;
	end process;
	
	-- Output depends solely on the current state
	process (state)
	begin	
		case state is
			when EW_HOLDON =>
				outputEW_int <= "001";
				outputNS_int <= "100";
			when EW_IDLEON=>
				outputEW_int <= "001";
                outputNS_int <= "100";
			when EW_SLOW=>
				outputEW_int <= "010";
                outputNS_int <= "100";
			when NS_HOLDON =>
				outputEW_int <= "100";
                outputNS_int <= "001";
			when NS_IDLEON =>
                outputEW_int <= "100";
                outputNS_int <= "001";
            when NS_SLOW =>
                outputEW_int <= "001";
                outputNS_int <= "010";            
		end case;
	end process;
	
	outputNS <= outputNS_int;
	outputEW <= outputEW_int;
	
end Behavioral;

