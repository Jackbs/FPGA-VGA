----------------------------------------------------------------------------------
-- Company: Victoria University of Wellington
-- Engineer: Stephen Winch
-- 
-- Create Date:    11:30:36 10/28/2010 
-- Design Name: 	 Moving block to simulate cars in VGA intersection 
-- Module Name:    Moving_Block - Behavioral 
-- Project Name: 
-- Target Devices: 	Spartan 3E
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Moving_Block is
    Port (	Colour : out  STD_LOGIC_VECTOR (7 downto 0);
			vert_scan : in  STD_LOGIC_VECTOR (9 downto 0);
			horz_scan : in  STD_LOGIC_VECTOR (9 downto 0);
			refresh_counter : in STD_LOGIC;
			direction : in STD_LOGIC;
			At_lights : out  STD_LOGIC;
			GO : in STD_LOGIC;
			North : in integer;
			East  : in integer;
			South : in integer;
			West  : in integer);
end Moving_Block;

architecture Behavioral of Moving_Block is

signal posy : integer :=North;
signal posx : integer :=West;
signal position : integer :=0;
signal dx: STD_LOGIC := '0';	--direction of x movement
signal dy: STD_LOGIC := '0';	--direction of y movement
signal Car_size_x : integer :=5;
signal Car_size_y : integer :=5;

begin
process(refresh_counter)
  begin
   if refresh_counter = '1' and refresh_counter'Event then
		if direction ='0' then --moving side to side
		position <= North+10;
			Car_size_y <=5;
			Car_size_x <= 15;
			if dx = '0' then
				if posx = West-30 and GO ='0' then
					posx<=posx;
					At_lights<='1';
				else
					posx <= posx + 1;
					At_lights<='0';
				end if;
			else
				if posx = East+15 and GO ='0' then
					posx<=posx;
					At_lights<='1';
				else
					posx <= posx -1;
					At_lights<='0';
				end if;
			end if;
		else -- moving up and down
		position <= West+10;
			Car_size_y <= 15;
			Car_size_x <=5;
			if dy = '0' then
				if posy = North-30 and GO ='0' then
					posy<=posy;
					At_lights<='1';
				else
					posy <= posy + 1;
					At_lights<='0';
				end if;
			else
				if posy = South+15 and GO ='0' then
					posy<=posy;
					At_lights<='1';
				else
					posy <= posy -1;
					At_lights<='0';
				end if;
			end if;
		end if;
	end if;

    if posx = 144 then
	  dx <= '0';
	  posy <= position;	--skip lanes back
	 elsif posx = 734 then
	  dx <= '1';
	  posy <= position +30;	-- skip lanes
	 end if;

    if posy = 35 then
	   dy <= '0';	 
		posx <= position +30; -- skip lanes back
	 elsif posy = 465 then
	   dy <= '1';
		posx <= position; -- skip lanes
	 end if;
 end process;
 
 Colour <= "00001111" when vert_scan >= posy and vert_scan < (posy+Car_size_y) and horz_scan >= posx and horz_scan < (posx+Car_size_x)
		else "00000000";
end Behavioral;

