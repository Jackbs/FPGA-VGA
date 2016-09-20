----------------------------------------------------------------------------------
-- Company: Victoria University of Wellington
-- Engineer: Stephen Winch
-- 
-- Create Date:    09:52:39 10/28/2010 
-- Design Name: 	 Map of Intersection for traffic light simulation
-- Module Name:    Intersection - Behavioral 
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

entity Intersection is
    Port (	Colour : out  STD_LOGIC_VECTOR (7 downto 0);
			vert_scan : in  STD_LOGIC_VECTOR (9 downto 0);
			horz_scan : in  STD_LOGIC_VECTOR (9 downto 0);
			North_Intersection : out integer;
			East_Intersection : out integer;
			South_Intersection : out integer;
			West_Intersection : out integer);
end Intersection;

architecture Behavioral of Intersection is

signal North : integer := 230;
signal East  : integer := 500;
signal South : integer := 290;
signal West  : integer := 440;
			  
 begin

Colour <= "00011100" when vert_scan < North-16 and horz_scan < West and vert_scan >35  and horz_scan >144 else			--Grass
			 "00011100"	when vert_scan < North-16 and horz_scan > East and vert_scan >35  and horz_scan <780 else		--Grass
			 "00011100"	when vert_scan > South+16 and horz_scan < West and vert_scan <565 and horz_scan >144 else		--Grass
			 "00011100"	when vert_scan > South+16 and horz_scan > East and vert_scan <565 and horz_scan <780 else		--Grass
			 
			 "00011100" when vert_scan < North and horz_scan < West-16 and vert_scan >35  and horz_scan >144 else		--Grass Beside Road
			 "00011100"	when vert_scan < North and horz_scan > East+16 and vert_scan >35  and horz_scan <780 else		--Grass Beside Road
			 "00011100"	when vert_scan > South and horz_scan < West-16 and vert_scan <565 and horz_scan >144 else		--Grass Beside Road
			 "00011100"	when vert_scan > South and horz_scan > East+16 and vert_scan <565 and horz_scan <780 else		--Grass Beside Road
			 
			 "11111100"	when horz_scan > (West +28) and horz_scan <(East - 28) and vert_scan >35 and vert_scan <North else		--yellow lines
  			 "11111100"	when vert_scan > (North + 28) and vert_scan <(South - 28) and horz_scan >144 and horz_scan <West else	--yellow lines
			 "11111100"	when horz_scan > (West +28) and horz_scan <(East - 28) and vert_scan >South and vert_scan <565 else		--yellow lines
  			 "11111100"	when vert_scan > (North + 28) and vert_scan <(South - 28) and horz_scan >East and horz_scan <780 else	--yellow lines
			 
			 "11111111"	when horz_scan > 436 and horz_scan <West and vert_scan >North and vert_scan <South else		--white lines
  			 "11111111"	when vert_scan > 226 and vert_scan <North and horz_scan >West and horz_scan <East else		--white lines
			 "11111111"	when horz_scan > East and horz_scan <504 and vert_scan >North and vert_scan <South else		--white lines
  			 "11111111"	when vert_scan > South and vert_scan <294 and horz_scan >West and horz_scan <East else		--white lines
			 "00000000";			 			 
			 
	North_Intersection <=North;
	East_Intersection <= East;
	South_Intersection <=South;
	West_Intersection <=West;
end Behavioral;

